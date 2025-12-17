package org.dromara.common.oss.core;

import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.IdUtil;
import com.alibaba.fastjson2.JSONObject;
import lombok.extern.slf4j.Slf4j;
import org.dromara.common.core.constant.Constants;
import org.dromara.common.core.utils.DateUtils;
import org.dromara.common.core.utils.StringUtils;
import org.dromara.common.core.utils.file.FileUtils;
import org.dromara.common.oss.constant.OssConstant;
import org.dromara.common.oss.entity.UploadResult;
import org.dromara.common.oss.enums.AccessPolicyType;
import org.dromara.common.oss.exception.OssException;
import org.dromara.common.oss.properties.OssProperties;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.async.AsyncRequestBody;
import software.amazon.awssdk.core.async.AsyncResponseTransformer;
import software.amazon.awssdk.core.async.BlockingInputStreamAsyncRequestBody;
import software.amazon.awssdk.core.async.ResponsePublisher;
import software.amazon.awssdk.http.nio.netty.NettyNioAsyncHttpClient;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.s3.model.*;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.transfer.s3.S3TransferManager;
import software.amazon.awssdk.transfer.s3.model.*;
import software.amazon.awssdk.transfer.s3.progress.LoggingTransferListener;

import java.io.*;
import java.net.URI;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.WritableByteChannel;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

/**
 * S3 存储协议 所有兼容S3协议的云厂商均支持
 * 阿里云 腾讯云 七牛云 minio
 *
 * @author AprilWind
 */
@Slf4j
public class OssClient {

    /**
     * 服务商
     */
    private final String configKey;

    /**
     * 配置属性
     */
    private final OssProperties properties;

    /**
     * Amazon S3 异步客户端
     */
    private final S3AsyncClient client;

    /**
     * 用于管理 S3 数据传输的高级工具
     */
    private final S3TransferManager transferManager;

    /**
     * AWS S3 预签名 URL 的生成器
     */
    private final S3Presigner presigner;

    /**
     * 空目录占位文件名
     */
    private static final String EMPTY_DIR_PLACEHOLDER = ".!@#$%^&";

    /**
     * 构造方法
     *
     * @param configKey     配置键
     * @param ossProperties Oss配置属性
     */
    public OssClient(String configKey, OssProperties ossProperties) {
        this.configKey = configKey;
        this.properties = ossProperties;
        try {
            // 创建 AWS 认证信息
            StaticCredentialsProvider credentialsProvider = StaticCredentialsProvider.create(
                AwsBasicCredentials.create(properties.getAccessKey(), properties.getSecretKey()));

            // MinIO 使用 HTTPS 限制使用域名访问，站点填域名。需要启用路径样式访问
            boolean isStyle = !StringUtils.containsAny(properties.getEndpoint(), OssConstant.CLOUD_SERVICE);

            // 创建AWS基于 Netty 的 S3 客户端
            this.client = S3AsyncClient.builder()
                .credentialsProvider(credentialsProvider)
                .endpointOverride(URI.create(getEndpoint()))
                .region(of())
                .forcePathStyle(isStyle)
                .httpClient(NettyNioAsyncHttpClient.builder()
                    .connectionTimeout(Duration.ofSeconds(60)).build())
                .build();

            //AWS基于 CRT 的 S3 AsyncClient 实例用作 S3 传输管理器的底层客户端
            this.transferManager = S3TransferManager.builder().s3Client(this.client).build();

            // 创建 S3 配置对象
            S3Configuration config = S3Configuration.builder().chunkedEncodingEnabled(false)
                .pathStyleAccessEnabled(isStyle).build();

            // 创建 预签名 URL 的生成器 实例，用于生成 S3 预签名 URL
            this.presigner = S3Presigner.builder()
                .region(of())
                .credentialsProvider(credentialsProvider)
                .endpointOverride(URI.create(getDomain()))
                .serviceConfiguration(config)
                .build();

        } catch (Exception e) {
            if (e instanceof OssException) {
                throw e;
            }
            throw new OssException("配置错误! 请检查系统配置:[" + e.getMessage() + "]");
        }
    }

    /**
     * 上传文件到 Amazon S3，并返回上传结果
     *
     * @param filePath    本地文件路径
     * @param key         在 Amazon S3 中的对象键
     * @param md5Digest   本地文件的 MD5 哈希值（可选）
     * @param contentType 文件内容类型
     * @return UploadResult 包含上传后的文件信息
     * @throws OssException 如果上传失败，抛出自定义异常
     */
    public UploadResult upload(Path filePath, String key, String md5Digest, String contentType) {
        try {
            // 构建上传请求对象
            FileUpload fileUpload = transferManager.uploadFile(
                x -> x.putObjectRequest(
                        y -> y.bucket(properties.getBucketName())
                            .key(key)
                            .contentMD5(StringUtils.isNotEmpty(md5Digest) ? md5Digest : null)
                            .contentType(contentType)
                            // 用于设置对象的访问控制列表（ACL）。不同云厂商对ACL的支持和实现方式有所不同，
                            // 因此根据具体的云服务提供商，你可能需要进行不同的配置（自行开启，阿里云有acl权限配置，腾讯云没有acl权限配置）
                            //.acl(getAccessPolicy().getObjectCannedACL())
                            .build())
                    .addTransferListener(LoggingTransferListener.create())
                    .source(filePath).build());

            // 等待上传完成并获取上传结果
            CompletedFileUpload uploadResult = fileUpload.completionFuture().join();
            String eTag = uploadResult.response().eTag();

            // 提取上传结果中的 ETag，并构建一个自定义的 UploadResult 对象
            return UploadResult.builder().url(getUrl() + StringUtils.SLASH + key).filename(key).eTag(eTag).build();
        } catch (Exception e) {
            // 捕获异常并抛出自定义异常
            throw new OssException("上传文件失败，请检查配置信息:[" + e.getMessage() + "]");
        } finally {
            // 无论上传是否成功，最终都会删除临时文件
            FileUtils.del(filePath);
        }
    }

    /**
     * 上传 InputStream 到 Amazon S3
     *
     * @param inputStream 要上传的输入流
     * @param key         在 Amazon S3 中的对象键
     * @param length      输入流的长度
     * @param contentType 文件内容类型
     * @return UploadResult 包含上传后的文件信息
     * @throws OssException 如果上传失败，抛出自定义异常
     */
    public UploadResult upload(InputStream inputStream, String key, Long length, String contentType) {
        // 如果输入流不是 ByteArrayInputStream，则将其读取为字节数组再创建 ByteArrayInputStream
        if (!(inputStream instanceof ByteArrayInputStream)) {
            inputStream = new ByteArrayInputStream(IoUtil.readBytes(inputStream));
        }
        try {
            // 创建异步请求体（length如果为空会报错）
            BlockingInputStreamAsyncRequestBody body = BlockingInputStreamAsyncRequestBody.builder()
                .contentLength(length)
                .subscribeTimeout(Duration.ofSeconds(120))
                .build();

            // 使用 transferManager 进行上传
            Upload upload = transferManager.upload(
                x -> x.requestBody(body).addTransferListener(LoggingTransferListener.create())
                    .putObjectRequest(
                        y -> y.bucket(properties.getBucketName())
                            .key(key)
                            .contentType(contentType)
                            // 用于设置对象的访问控制列表（ACL）。不同云厂商对ACL的支持和实现方式有所不同，
                            // 因此根据具体的云服务提供商，你可能需要进行不同的配置（自行开启，阿里云有acl权限配置，腾讯云没有acl权限配置）
                            //.acl(getAccessPolicy().getObjectCannedACL())
                            .build())
                    .build());

            // 将输入流写入请求体
            body.writeInputStream(inputStream);

            // 等待文件上传操作完成
            CompletedUpload uploadResult = upload.completionFuture().join();
            String eTag = uploadResult.response().eTag();

            // 提取上传结果中的 ETag，并构建一个自定义的 UploadResult 对象
            return UploadResult.builder().url(getUrl() + StringUtils.SLASH + key).filename(key).eTag(eTag).build();
        } catch (Exception e) {
            throw new OssException("上传文件失败，请检查配置信息:[" + e.getMessage() + "]");
        }
    }

    /**
     * 下载文件从 Amazon S3 到临时目录
     *
     * @param path 文件在 Amazon S3 中的对象键
     * @return 下载后的文件在本地的临时路径
     * @throws OssException 如果下载失败，抛出自定义异常
     */
    public Path fileDownload(String path) {
        // 构建临时文件
        Path tempFilePath = FileUtils.createTempFile().toPath();
        // 使用 S3TransferManager 下载文件
        FileDownload downloadFile = transferManager.downloadFile(
            x -> x.getObjectRequest(
                    y -> y.bucket(properties.getBucketName())
                        .key(removeBaseUrl(path))
                        .build())
                .addTransferListener(LoggingTransferListener.create())
                .destination(tempFilePath)
                .build());
        // 等待文件下载操作完成
        downloadFile.completionFuture().join();
        return tempFilePath;
    }

    /**
     * 下载文件从 Amazon S3 到 输出流
     *
     * @param key      文件在 Amazon S3 中的对象键
     * @param out      输出流
     * @param consumer 自定义处理逻辑
     * @throws OssException 如果下载失败，抛出自定义异常
     */
    public void download(String key, OutputStream out, Consumer<Long> consumer) {
        try {
            this.download(key, consumer).writeTo(out);
        } catch (Exception e) {
            throw new OssException("文件下载失败，错误信息:[" + e.getMessage() + "]");
        }
    }

    /**
     * 下载文件从 Amazon S3 到 输出流
     *
     * @param key                   文件在 Amazon S3 中的对象键
     * @param contentLengthConsumer 文件大小消费者函数
     * @return 写出订阅器
     * @throws OssException 如果下载失败，抛出自定义异常
     */
    public WriteOutSubscriber<OutputStream> download(String key, Consumer<Long> contentLengthConsumer) {
        try {
            // 构建下载请求
            DownloadRequest<ResponsePublisher<GetObjectResponse>> publisherDownloadRequest = DownloadRequest.builder()
                // 文件对象
                .getObjectRequest(y -> y.bucket(properties.getBucketName())
                    .key(key)
                    .build())
                .addTransferListener(LoggingTransferListener.create())
                // 使用发布订阅转换器
                .responseTransformer(AsyncResponseTransformer.toPublisher())
                .build();

            // 使用 S3TransferManager 下载文件
            Download<ResponsePublisher<GetObjectResponse>> publisherDownload = transferManager.download(publisherDownloadRequest);
            // 获取下载发布订阅转换器
            ResponsePublisher<GetObjectResponse> publisher = publisherDownload.completionFuture().join().result();
            // 执行文件大小消费者函数
            Optional.ofNullable(contentLengthConsumer)
                .ifPresent(lengthConsumer -> lengthConsumer.accept(publisher.response().contentLength()));

            // 构建写出订阅器对象
            return out -> {
                // 创建可写入的字节通道
                try (WritableByteChannel channel = Channels.newChannel(out)) {
                    // 订阅数据
                    publisher.subscribe(byteBuffer -> {
                        while (byteBuffer.hasRemaining()) {
                            try {
                                channel.write(byteBuffer);
                            } catch (IOException e) {
                                throw new RuntimeException(e);
                            }
                        }
                    }).join();
                }
            };
        } catch (Exception e) {
            throw new OssException("文件下载失败，错误信息:[" + e.getMessage() + "]");
        }
    }

    /**
     * 删除云存储服务中指定路径下文件
     *
     * @param path 指定路径
     */
    public void delete(String path) {
        try {
            client.deleteObject(
                x -> x.bucket(properties.getBucketName())
                    .key(removeBaseUrl(path))
                    .build());
        } catch (Exception e) {
            throw new OssException("删除文件失败，请检查配置信息:[" + e.getMessage() + "]");
        }
    }

    /**
     * 获取私有URL链接
     *
     * @param objectKey   对象KEY
     * @param expiredTime 链接授权到期时间
     */
    public String getPrivateUrl(String objectKey, Duration expiredTime) {
        // 使用 AWS S3 预签名 URL 的生成器 获取对象的预签名 URL
        URL url = presigner.presignGetObject(
                x -> x.signatureDuration(expiredTime)
                    .getObjectRequest(
                        y -> y.bucket(properties.getBucketName())
                            .key(objectKey)
                            .build())
                    .build())
            .url();
        return url.toString();
    }

    /**
     * 上传 byte[] 数据到 Amazon S3，使用指定的后缀构造对象键。
     *
     * @param data   要上传的 byte[] 数据
     * @param suffix 对象键的后缀
     * @return UploadResult 包含上传后的文件信息
     * @throws OssException 如果上传失败，抛出自定义异常
     */
    public UploadResult uploadSuffix(byte[] data, String suffix, String contentType) {
        return upload(new ByteArrayInputStream(data), getPath(properties.getPrefix(), suffix), Long.valueOf(data.length), contentType);
    }

    /**
     * 上传 InputStream 到 Amazon S3，使用指定的后缀构造对象键。
     *
     * @param inputStream 要上传的输入流
     * @param suffix      对象键的后缀
     * @param length      输入流的长度
     * @return UploadResult 包含上传后的文件信息
     * @throws OssException 如果上传失败，抛出自定义异常
     */
    public UploadResult uploadSuffix(InputStream inputStream, String suffix, Long length, String contentType) {
        return upload(inputStream, getPath(properties.getPrefix(), suffix), length, contentType);
    }

    /**
     * 上传文件到 Amazon S3，使用指定的后缀构造对象键
     *
     * @param file   要上传的文件
     * @param suffix 对象键的后缀
     * @return UploadResult 包含上传后的文件信息
     * @throws OssException 如果上传失败，抛出自定义异常
     */
    public UploadResult uploadSuffix(File file, String suffix) {
        return upload(file.toPath(), getPath(properties.getPrefix(), suffix), null, FileUtils.getMimeType(suffix));
    }

    /**
     * 获取文件输入流
     *
     * @param path 完整文件路径
     * @return 输入流
     */
    public InputStream getObjectContent(String path) throws IOException {
        // 下载文件到临时目录
        Path tempFilePath = fileDownload(path);
        // 创建输入流
        InputStream inputStream = Files.newInputStream(tempFilePath);
        // 删除临时文件
        FileUtils.del(tempFilePath);
        // 返回对象内容的输入流
        return inputStream;
    }

    /**
     * 获取 S3 客户端的终端点 URL
     *
     * @return 终端点 URL
     */
    public String getEndpoint() {
        // 根据配置文件中的是否使用 HTTPS，设置协议头部
        String header = getIsHttps();
        // 拼接协议头部和终端点，得到完整的终端点 URL
        return header + properties.getEndpoint();
    }

    /**
     * 获取 S3 客户端的终端点 URL（自定义域名）
     *
     * @return 终端点 URL
     */
    public String getDomain() {
        // 从配置中获取域名、终端点、是否使用 HTTPS 等信息
        String domain = properties.getDomain();
        String endpoint = properties.getEndpoint();
        String header = getIsHttps();

        // 如果是云服务商，直接返回域名或终端点
        if (StringUtils.containsAny(endpoint, OssConstant.CLOUD_SERVICE)) {
            return StringUtils.isNotEmpty(domain) ? header + domain : header + endpoint;
        }

        // 如果是 MinIO，处理域名并返回
        if (StringUtils.isNotEmpty(domain)) {
            return domain.startsWith(Constants.HTTPS) || domain.startsWith(Constants.HTTP) ? domain : header + domain;
        }

        // 返回终端点
        return header + endpoint;
    }

    /**
     * 根据传入的 region 参数返回相应的 AWS 区域
     * 如果 region 参数非空，使用 Region.of 方法创建并返回对应的 AWS 区域对象
     * 如果 region 参数为空，返回一个默认的 AWS 区域（例如，us-east-1），作为广泛支持的区域
     *
     * @return 对应的 AWS 区域对象，或者默认的广泛支持的区域（us-east-1）
     */
    public Region of() {
        //AWS 区域字符串
        String region = properties.getRegion();
        // 如果 region 参数非空，使用 Region.of 方法创建对应的 AWS 区域对象，否则返回默认区域
        return StringUtils.isNotEmpty(region) ? Region.of(region) : Region.US_EAST_1;
    }

    /**
     * 获取云存储服务的URL
     *
     * @return 文件路径
     */
    public String getUrl() {
        String domain = properties.getDomain();
        String endpoint = properties.getEndpoint();
        String header = getIsHttps();
        // 云服务商直接返回
        if (StringUtils.containsAny(endpoint, OssConstant.CLOUD_SERVICE)) {
            return header + (StringUtils.isNotEmpty(domain) ? domain : properties.getBucketName() + "." + endpoint);
        }
        // MinIO 单独处理
        if (StringUtils.isNotEmpty(domain)) {
            // 如果 domain 以 "https://" 或 "http://" 开头
            return (domain.startsWith(Constants.HTTPS) || domain.startsWith(Constants.HTTP)) ?
                domain + StringUtils.SLASH + properties.getBucketName() : header + domain + StringUtils.SLASH + properties.getBucketName();
        }
        return header + endpoint + StringUtils.SLASH + properties.getBucketName();
    }

    /**
     * 生成一个符合特定规则的、唯一的文件路径。通过使用日期、UUID、前缀和后缀等元素的组合，确保了文件路径的独一无二性
     *
     * @param prefix 前缀
     * @param suffix 后缀
     * @return 文件路径
     */
    public String getPath(String prefix, String suffix) {
        // 生成uuid
        String uuid = IdUtil.fastSimpleUUID();
        // 生成日期路径
        String datePath = DateUtils.datePath();
        // 拼接路径
        String path = StringUtils.isNotEmpty(prefix) ?
            prefix + StringUtils.SLASH + datePath + StringUtils.SLASH + uuid : datePath + StringUtils.SLASH + uuid;
        return path + suffix;
    }

    /**
     * 移除路径中的基础URL部分，得到相对路径
     *
     * @param path 完整的路径，包括基础URL和相对路径
     * @return 去除基础URL后的相对路径
     */
    public String removeBaseUrl(String path) {
        return path.replace(getUrl() + StringUtils.SLASH, "");
    }

    /**
     * 服务商
     */
    public String getConfigKey() {
        return configKey;
    }

    /**
     * 获取是否使用 HTTPS 的配置，并返回相应的协议头部。
     *
     * @return 协议头部，根据是否使用 HTTPS 返回 "https://" 或 "http://"
     */
    public String getIsHttps() {
        return OssConstant.IS_HTTPS.equals(properties.getIsHttps()) ? Constants.HTTPS : Constants.HTTP;
    }

    /**
     * 检查配置是否相同
     */
    public boolean checkPropertiesSame(OssProperties properties) {
        return this.properties.equals(properties);
    }

    /**
     * 获取当前桶权限类型
     *
     * @return 当前桶权限类型code
     */
    public AccessPolicyType getAccessPolicy() {
        return AccessPolicyType.getByType(properties.getAccessPolicy());
    }

    // ==================== 辅助方法 ====================

    /**
     * 根据文件名获取Content-Type
     *
     * @param fileName 文件名
     * @return Content-Type
     */
    private String getContentTypeFromFileName(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0) {
            String suffix = fileName.substring(lastDotIndex);
            return FileUtils.getMimeType(suffix);
        }
        return "application/octet-stream";
    }

    /**
     * 服务端复制对象（不经过客户端，性能最优）
     *
     * @param sourceKey 源对象键
     * @param targetKey 目标对象键
     * @throws OssException 如果复制失败
     */
    private void copyObjectOnServer(String sourceKey, String targetKey) {
        try {
            // 构建复制源（格式: bucket/key）
            String copySource = properties.getBucketName() + "/" + sourceKey;
            // 执行服务端复制
            client.copyObject(
                x -> x.sourceBucket(properties.getBucketName())
                    .sourceKey(sourceKey)
                    .destinationBucket(properties.getBucketName())
                    .destinationKey(targetKey)
                    .build()
            ).join();
        } catch (Exception e) {
            throw new OssException("服务端复制对象失败: " + sourceKey + " -> " + targetKey +
                                   ", 错误: " + e.getMessage());
        }
    }

    /**
     * 收集文件路径中的所有父目录
     *
     * @param filePath    完整文件路径
     * @param directories 目录集合
     */
    private void collectAllParentDirectories(String filePath, java.util.Set<String> directories) {
        int lastSlashIndex = filePath.lastIndexOf('/');
        if (lastSlashIndex <= 0) {
            return;
        }
        String dirPath = filePath.substring(0, lastSlashIndex);
        String[] parts = dirPath.split("/");
        StringBuilder currentPath = new StringBuilder();
        for (String part : parts) {
            if (!currentPath.isEmpty()) {
                currentPath.append("/");
            }
            currentPath.append(part);
            directories.add(currentPath.toString());
        }
    }

    /**
     * 将单个文件添加到ZIP中
     *
     * @param objectKey    S3对象键
     * @param zipEntryName ZIP中的条目名称
     * @param zipOut       ZIP输出流
     * @throws IOException 如果IO操作失败
     */
    private void addFileToZip(String objectKey, String zipEntryName, ZipOutputStream zipOut) throws IOException {
        try {
            // 创建ZIP条目
            ZipEntry zipEntry = new ZipEntry(zipEntryName);
            zipOut.putNextEntry(zipEntry);
            // 下载文件内容
            DownloadRequest<ResponsePublisher<GetObjectResponse>> downloadRequest = DownloadRequest.builder()
                .getObjectRequest(y -> y.bucket(properties.getBucketName())
                    .key(objectKey)
                    .build())
                .responseTransformer(AsyncResponseTransformer.toPublisher())
                .build();
            Download<ResponsePublisher<GetObjectResponse>> download = transferManager.download(downloadRequest);
            ResponsePublisher<GetObjectResponse> publisher = download.completionFuture().join().result();
            // 使用临时缓冲区写入ZIP
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            WritableByteChannel channel = Channels.newChannel(buffer);
            publisher.subscribe(byteBuffer -> {
                while (byteBuffer.hasRemaining()) {
                    try {
                        channel.write(byteBuffer);
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
            }).join();
            channel.close();
            // 将缓冲区内容写入ZIP
            buffer.writeTo(zipOut);
            zipOut.closeEntry();
            log.debug("文件已添加到ZIP: {}", zipEntryName);
        } catch (Exception e) {
            throw new IOException("添加文件到ZIP失败: " + objectKey, e);
        }
    }

    /**
     * 递归列出所有文件并添加到ZIP中（排除占位文件）
     *
     * @param prefix          当前目录前缀
     * @param zipOut          ZIP输出流
     * @param basePrefix      基础前缀，用于计算相对路径
     * @param topLevelDirName 顶层目录名称
     * @throws IOException 如果IO操作失败
     */
    private void listAllFiles(String prefix, ZipOutputStream zipOut, String basePrefix, String topLevelDirName) throws IOException {
        try {
            // 构建列表请求
            ListObjectsV2Request request = ListObjectsV2Request.builder()
                .bucket(properties.getBucketName())
                .prefix(prefix)
                .delimiter("/")
                .build();
            ListObjectsV2Response response = client.listObjectsV2(request).join();
            // 处理当前目录下的文件
            List<S3Object> contents = response.contents();
            for (S3Object s3Object : contents) {
                String key = s3Object.key();
                // 跳过目录标记对象（以/结尾的空对象）
                if (key.endsWith("/")) {
                    continue;
                }
                // 跳过占位文件（关键！）
                if (key.endsWith("/" + EMPTY_DIR_PLACEHOLDER)) {
                    log.debug("跳过占位文件: {}", key);
                    continue;
                }
                // 计算ZIP中的相对路径（包含顶层目录）
                String relativePath = key.substring(basePrefix.length());
                if (relativePath.isEmpty()) {
                    continue;
                }
                // 拼接顶层目录名称
                String zipEntryName = topLevelDirName + "/" + relativePath;
                // 下载文件并写入ZIP
                addFileToZip(key, zipEntryName, zipOut);
            }
            // 递归处理子目录
            List<String> commonPrefixes = response.commonPrefixes().stream()
                .map(CommonPrefix::prefix)
                .toList();
            for (String subPrefix : commonPrefixes) {
                listAllFiles(subPrefix, zipOut, basePrefix, topLevelDirName);
            }
        } catch (Exception e) {
            throw new IOException("列出文件失败: " + e.getMessage(), e);
        }
    }

    /**
     * 检查目录下是否有内容
     *
     * @param dirPrefix 目录前缀（以/结尾）
     * @return true-有内容, false-无内容
     */
    private boolean checkDirectoryHasContent(String dirPrefix) {
        try {
            ListObjectsV2Request request = ListObjectsV2Request.builder()
                .bucket(properties.getBucketName())
                .prefix(dirPrefix)
                .maxKeys(1)
                .build();
            ListObjectsV2Response response = client.listObjectsV2(request).join();
            return !response.contents().isEmpty();
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 为文件或目录名添加随机后缀
     *
     * @param name   原始名称
     * @param isFile 是否是文件
     * @return 带随机后缀的名称
     */
    private String renameWithSuffix(String name, boolean isFile) {
        String suffix = generateRandomSuffix();
        if (isFile) {
            int dotIndex = name.lastIndexOf('.');
            if (dotIndex > 0) {
                return name.substring(0, dotIndex) + "_" + suffix + name.substring(dotIndex);
            }
        }
        return name + "_" + suffix;
    }

    /**
     * 解决路径冲突（处理文件和目录同名情况）
     *
     * @param basePath     基础路径
     * @param originalPath 原始ZIP内路径
     * @param pathMapping  路径映射缓存
     * @return 解决冲突后的路径
     */
    private String resolvePathConflicts(String basePath, String originalPath, java.util.Map<String, String> pathMapping) {
        String[] parts = originalPath.split("/");
        StringBuilder resolvedPath = new StringBuilder();
        for (int i = 0; i < parts.length; i++) {
            String part = parts[i];
            boolean isFile = (i == parts.length - 1);
            // 构建当前层级的原始路径（用于缓存查找）
            String currentOriginalPath = String.join("/", java.util.Arrays.copyOfRange(parts, 0, i + 1));
            // 检查缓存中是否已有映射
            if (pathMapping.containsKey(currentOriginalPath)) {
                String mappedName = pathMapping.get(currentOriginalPath);
                if (!resolvedPath.isEmpty()) {
                    resolvedPath.append("/");
                }
                // 只取映射路径的最后一段
                String[] mappedParts = mappedName.split("/");
                resolvedPath.append(mappedParts[mappedParts.length - 1]);
                continue;
            }
            // 构建当前检查路径
            String checkPath = basePath + (resolvedPath.isEmpty() ? "" : resolvedPath.toString() + "/") + part;
            String finalName = part;
            if (isFile) {
                // 检查文件是否存在
                if (checkFileExists(checkPath)) {
                    finalName = renameWithSuffix(part, true);
                    log.info("文件 {} 已存在，重命名为: {}", part, finalName);
                }
            } else {
                // 检查目录是否存在
                String dirCheckPath = checkPath + "/";
                if (checkDirectoryHasContent(dirCheckPath)) {
                    finalName = renameWithSuffix(part, false);
                    log.info("目录 {} 已存在，重命名为: {}", part, finalName);
                }
            }
            // 更新路径映射
            if (!resolvedPath.isEmpty()) {
                resolvedPath.append("/");
            }
            resolvedPath.append(finalName);
            pathMapping.put(currentOriginalPath, resolvedPath.toString());
        }
        return resolvedPath.toString();
    }

    /**
     * 提取顶层目录名称
     *
     * @param directoryPath 目录路径
     * @return 顶层目录名称
     */
    private String extractTopLevelDirName(String directoryPath) {
        // 去掉首尾的斜杠
        String path = directoryPath.trim();
        if (path.startsWith("/")) {
            path = path.substring(1);
        }
        if (path.endsWith("/")) {
            path = path.substring(0, path.length() - 1);
        }
        // 如果路径为空，返回默认名称
        if (path.isEmpty()) {
            return "root";
        }
        // 获取最后一个路径段作为顶层目录名
        int lastSlashIndex = path.lastIndexOf('/');
        if (lastSlashIndex >= 0) {
            return path.substring(lastSlashIndex + 1);
        }
        return path;
    }

    /**
     * 生成8位随机数字字符串
     *
     * @return 随机数字字符串
     */
    private String generateRandomSuffix() {
        StringBuilder sb = new StringBuilder(8);
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < 8; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }

    /**
     * 检查文件是否存在
     *
     * @param key 文件键
     * @return true-存在, false-不存在
     */
    private boolean checkFileExists(String key) {
        try {
            client.headObject(
                builder -> builder
                    .bucket(properties.getBucketName())
                    .key(key)
                    .build()
            ).join();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 规范化文件路径：去掉开头的"/"
     *
     * @param path 原始路径
     * @return 规范化后的路径
     */
    private String normalizeFilePath(String path) {
        if (path == null || path.isEmpty()) {
            return path;
        }
        return path.startsWith("/") ? path.substring(1) : path;
    }

    /**
     * 规范化目录路径：去掉开头的"/"，确保结尾有"/"
     *
     * @param path 原始路径
     * @return 规范化后的路径
     */
    private String normalizeDirectoryPath(String path) {
        if (path == null) {
            return "";
        }

        String normalized = path.trim();

        // 去掉开头的所有"/"
        while (normalized.startsWith("/")) {
            normalized = normalized.substring(1);
        }

        // 去掉结尾的所有"/"
        while (normalized.endsWith("/")) {
            normalized = normalized.substring(0, normalized.length() - 1);
        }

        // 如果不为空，确保结尾有"/"
        if (!normalized.isEmpty()) {
            normalized = normalized + "/";
        }

        return normalized;
    }

    /**
     * 为文件或目录名添加随机后缀（统一的重命名逻辑）
     *
     * @param name   原始名称
     * @param isFile 是否是文件
     * @return 带随机后缀的名称
     */
    private String addRandomSuffix(String name, boolean isFile) {
        String suffix = generateRandomSuffix();

        if (isFile) {
            int dotIndex = name.lastIndexOf('.');
            if (dotIndex > 0) {
                return name.substring(0, dotIndex) + "_" + suffix + name.substring(dotIndex);
            }
        }
        return name + "_" + suffix;
    }

    /**
     * 创建单个占位文件
     *
     * @param directoryPath 目录路径（不带结尾斜杠）
     */
    private void createPlaceholderFile(String directoryPath) {
        String placeholderKey = directoryPath + "/" + EMPTY_DIR_PLACEHOLDER;

        if (!checkFileExists(placeholderKey)) {
            client.putObject(
                request -> request
                    .bucket(properties.getBucketName())
                    .key(placeholderKey)
                    .contentType("application/octet-stream")
                    .contentLength(0L)
                    .build(),
                AsyncRequestBody.empty()
            ).join();

            log.debug("创建占位文件: {}", placeholderKey);
        } else {
            log.debug("占位文件已存在，跳过: {}", placeholderKey);
        }
    }

    /**
     * 为多个目录批量创建占位文件
     *
     * @param directories 目录路径集合
     * @return 实际创建的占位文件数量
     */
    private int createPlaceholdersForDirectories(java.util.Set<String> directories) {
        int count = 0;
        for (String dirPath : directories) {
            String placeholderKey = dirPath + "/" + EMPTY_DIR_PLACEHOLDER;
            if (!checkFileExists(placeholderKey)) {
                client.putObject(
                    request -> request
                        .bucket(properties.getBucketName())
                        .key(placeholderKey)
                        .contentType("application/octet-stream")
                        .contentLength(0L)
                        .build(),
                    AsyncRequestBody.empty()
                ).join();
                count++;
                log.debug("创建占位文件: {}", placeholderKey);
            }
        }
        return count;
    }

    /**
     * 递归处理分页删除对象
     *
     * @param prefix            目录前缀
     * @param continuationToken 分页token
     * @param deleteAction      删除动作（lambda表达式）
     * @return 处理的对象数量
     */
    private int processPaginatedObjects(String prefix, String continuationToken,
                                        java.util.function.BiConsumer<S3Object, Integer> deleteAction) {
        int processedCount = 0;

        try {
            ListObjectsV2Request request = ListObjectsV2Request.builder()
                .bucket(properties.getBucketName())
                .prefix(prefix)
                .continuationToken(continuationToken)
                .build();

            ListObjectsV2Response response = client.listObjectsV2(request).join();

            // 处理当前批次的所有对象
            List<S3Object> contents = response.contents();
            for (S3Object s3Object : contents) {
                deleteAction.accept(s3Object, processedCount);
                processedCount++;
            }

            // 如果还有更多对象，递归继续处理
            if (response.isTruncated()) {
                processedCount += processPaginatedObjects(prefix, response.nextContinuationToken(), deleteAction);
            }

        } catch (Exception e) {
            throw new OssException("处理分页对象失败: " + e.getMessage());
        }

        return processedCount;
    }

    /**
     * 移动单个文件到目标目录
     */
    private int moveSingleFile(String sourceKey, String targetPrefix) {
        String fileName = sourceKey.contains("/")
            ? sourceKey.substring(sourceKey.lastIndexOf('/') + 1)
            : sourceKey;

        String targetKey = targetPrefix + fileName;
        if (checkFileExists(targetKey)) {
            fileName = addRandomSuffix(fileName, true);
            targetKey = targetPrefix + fileName;
            log.info("目标存在同名文件，重命名为: {}", fileName);
        }

        copyObjectOnServer(sourceKey, targetKey);

        client.deleteObject(
            x -> x.bucket(properties.getBucketName())
                .key(sourceKey)
                .build()
        ).join();

        log.debug("文件移动成功: {} -> {}", sourceKey, targetKey);
        return 1;
    }

    /**
     * 移动整个目录到目标目录
     */
    private int moveEntireDirectory(String sourceDirPath, String targetPrefix) {
        String dirName = sourceDirPath.contains("/")
            ? sourceDirPath.substring(sourceDirPath.lastIndexOf('/') + 1)
            : sourceDirPath;

        String targetDirPath = targetPrefix + dirName;
        if (checkDirectoryHasContent(targetDirPath + "/")) {
            dirName = addRandomSuffix(dirName, false);
            targetDirPath = targetPrefix + dirName;
            log.info("目标存在同名目录，重命名为: {}", dirName);
        }

        String sourcePrefix = sourceDirPath + "/";
        String newTargetPrefix = targetDirPath + "/";

        int movedCount = 0;

        try {
            ListObjectsV2Request request = ListObjectsV2Request.builder()
                .bucket(properties.getBucketName())
                .prefix(sourcePrefix)
                .build();

            ListObjectsV2Response response = client.listObjectsV2(request).join();

            for (S3Object s3Object : response.contents()) {
                String sourceKey = s3Object.key();
                String relativePath = sourceKey.substring(sourcePrefix.length());
                String targetKey = newTargetPrefix + relativePath;

                copyObjectOnServer(sourceKey, targetKey);

                client.deleteObject(
                    x -> x.bucket(properties.getBucketName())
                        .key(sourceKey)
                        .build()
                ).join();

                movedCount++;
                log.debug("文件移动成功: {} -> {}", sourceKey, targetKey);
            }

            if (response.isTruncated()) {
                movedCount += processPaginatedObjects(sourcePrefix, response.nextContinuationToken(),
                    (s3Object, count) -> {
                        String sourceKey = s3Object.key();
                        String relativePath = sourceKey.substring(sourcePrefix.length());
                        String targetKey = newTargetPrefix + relativePath;

                        copyObjectOnServer(sourceKey, targetKey);

                        client.deleteObject(
                            x -> x.bucket(properties.getBucketName())
                                .key(sourceKey)
                                .build()
                        ).join();

                        log.debug("文件移动成功: {} -> {}", sourceKey, targetKey);
                    });
            }

        } catch (Exception e) {
            throw new OssException("移动目录内容失败: " + e.getMessage());
        }

        return movedCount;
    }

    /**
     * 下载文件到输出流(辅助方法)
     *
     * @param normalizedFilePath 规范化后的文件路径
     * @param outputStream       输出流
     * @throws IOException 如果IO操作失败
     */
    private void downloadFileToStream(String normalizedFilePath, OutputStream outputStream) throws IOException {
        // 构建下载请求
        DownloadRequest<ResponsePublisher<GetObjectResponse>> downloadRequest = DownloadRequest.builder()
            .getObjectRequest(y -> y.bucket(properties.getBucketName())
                .key(normalizedFilePath)
                .build())
            .addTransferListener(LoggingTransferListener.create())
            .responseTransformer(AsyncResponseTransformer.toPublisher())
            .build();

        // 使用 S3TransferManager 下载文件
        Download<ResponsePublisher<GetObjectResponse>> download = transferManager.download(downloadRequest);

        // 获取下载发布订阅转换器
        ResponsePublisher<GetObjectResponse> publisher = download.completionFuture().join().result();

        // 创建可写入的字节通道
        try (WritableByteChannel channel = Channels.newChannel(outputStream)) {
            // 订阅数据并写入输出流
            publisher.subscribe(byteBuffer -> {
                while (byteBuffer.hasRemaining()) {
                    try {
                        channel.write(byteBuffer);
                    } catch (IOException e) {
                        throw new RuntimeException("写入数据失败: " + e.getMessage(), e);
                    }
                }
            }).join();
        }
    }

    /**
     * 下载目录并打包成ZIP到输出流(辅助方法)
     *
     * @param directoryPath 目录路径
     * @param outputStream  输出流
     * @throws IOException 如果IO操作失败
     */
    private void downloadDirectoryAsZipInternal(String directoryPath, OutputStream outputStream) throws IOException {
        ZipOutputStream zipOut = null;
        try {
            String prefix = normalizeDirectoryPath(directoryPath);
            String topLevelDirName = extractTopLevelDirName(directoryPath);

            zipOut = new ZipOutputStream(outputStream);
            listAllFiles(prefix, zipOut, prefix, topLevelDirName);
            zipOut.finish();

        } finally {
            if (zipOut != null) {
                try {
                    zipOut.close();
                } catch (IOException e) {
                    log.error("关闭ZIP输出流失败", e);
                }
            }
        }
    }

    /**
     * 将目录下的所有文件添加到ZIP中,保持相对路径结构(辅助方法,排除占位文件)
     *
     * @param currentPrefix   当前遍历的目录前缀
     * @param basePrefix      基础前缀(用于计算相对路径)
     * @param zipBasePath     ZIP中的基础路径
     * @param zipOut          ZIP输出流
     * @param addedZipEntries 已添加的ZIP条目集合(用于去重)
     * @return 添加的文件数量
     * @throws IOException 如果IO操作失败
     */
    private int addDirectoryFilesToZipWithBasePath(String currentPrefix, String basePrefix,
                                                   String zipBasePath, ZipOutputStream zipOut,
                                                   java.util.Set<String> addedZipEntries) throws IOException {
        int fileCount = 0;

        try {
            // 构建列表请求
            ListObjectsV2Request request = ListObjectsV2Request.builder()
                .bucket(properties.getBucketName())
                .prefix(currentPrefix)
                .delimiter("/")
                .build();

            ListObjectsV2Response response = client.listObjectsV2(request).join();

            // 处理当前目录下的文件
            List<S3Object> contents = response.contents();
            for (S3Object s3Object : contents) {
                String key = s3Object.key();

                // 跳过目录标记对象
                if (key.endsWith("/")) {
                    continue;
                }

                // 跳过占位文件
                if (key.endsWith("/" + EMPTY_DIR_PLACEHOLDER)) {
                    log.debug("跳过占位文件: {}", key);
                    continue;
                }

                // 计算相对于basePrefix的相对路径
                String relativePath = key.substring(basePrefix.length());
                if (relativePath.isEmpty()) {
                    continue;
                }

                // 去掉开头的斜杠
                if (relativePath.startsWith("/")) {
                    relativePath = relativePath.substring(1);
                }

                // 构建ZIP中的完整路径：zipBasePath + 相对路径
                String zipEntryName = zipBasePath + "/" + relativePath;

                // 检查是否已添加
                if (!addedZipEntries.contains(zipEntryName)) {
                    addSingleFileToZip(key, zipEntryName, zipOut);
                    addedZipEntries.add(zipEntryName);
                    fileCount++;
                    log.debug("已添加文件到ZIP: {}", zipEntryName);
                } else {
                    log.warn("ZIP条目已存在，跳过: {}", zipEntryName);
                }
            }

            // 递归处理子目录
            List<String> commonPrefixes = response.commonPrefixes().stream()
                .map(CommonPrefix::prefix)
                .toList();

            for (String subPrefix : commonPrefixes) {
                // 递归时保持basePrefix和zipBasePath不变
                fileCount += addDirectoryFilesToZipWithBasePath(subPrefix, basePrefix, zipBasePath, zipOut, addedZipEntries);
            }

        } catch (Exception e) {
            throw new IOException("添加目录文件到ZIP失败: " + e.getMessage(), e);
        }

        return fileCount;
    }

    /**
     * 从文件路径中提取文件名(辅助方法)
     *
     * @param filePath 文件路径
     * @return 文件名
     */
    private String extractFileName(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return "unnamed";
        }

        // 去掉结尾的斜杠
        String path = filePath;
        while (path.endsWith("/")) {
            path = path.substring(0, path.length() - 1);
        }

        // 获取最后一个斜杠后的内容
        int lastSlashIndex = path.lastIndexOf('/');
        if (lastSlashIndex >= 0) {
            return path.substring(lastSlashIndex + 1);
        }

        return path;
    }

    /**
     * 生成ZIP中的唯一文件名(处理同名冲突)(辅助方法)
     *
     * @param originalName 原始文件名
     * @param nameCountMap 名称计数Map
     * @return 唯一的文件名
     */
    private String generateUniqueNameInZip(String originalName, java.util.Map<String, Integer> nameCountMap) {
        if (!nameCountMap.containsKey(originalName)) {
            nameCountMap.put(originalName, 1);
            return originalName;
        }

        // 存在同名,添加序号
        int count = nameCountMap.get(originalName);
        nameCountMap.put(originalName, count + 1);

        // 处理文件扩展名
        int lastDotIndex = originalName.lastIndexOf('.');
        if (lastDotIndex > 0) {
            String nameWithoutExt = originalName.substring(0, lastDotIndex);
            String extension = originalName.substring(lastDotIndex);
            return nameWithoutExt + "_(" + count + ")" + extension;
        } else {
            return originalName + "_(" + count + ")";
        }
    }

    /**
     * 将单个文件添加到ZIP中(辅助方法)
     *
     * @param objectKey    S3对象键
     * @param zipEntryName ZIP中的条目名称
     * @param zipOut       ZIP输出流
     * @throws IOException 如果IO操作失败
     */
    private void addSingleFileToZip(String objectKey, String zipEntryName, ZipOutputStream zipOut) throws IOException {
        try {
            // 创建ZIP条目
            ZipEntry zipEntry = new ZipEntry(zipEntryName);
            zipOut.putNextEntry(zipEntry);

            // 下载文件内容
            DownloadRequest<ResponsePublisher<GetObjectResponse>> downloadRequest = DownloadRequest.builder()
                .getObjectRequest(y -> y.bucket(properties.getBucketName())
                    .key(objectKey)
                    .build())
                .responseTransformer(AsyncResponseTransformer.toPublisher())
                .build();

            Download<ResponsePublisher<GetObjectResponse>> download = transferManager.download(downloadRequest);
            ResponsePublisher<GetObjectResponse> publisher = download.completionFuture().join().result();

            // 使用临时缓冲区写入ZIP
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            WritableByteChannel channel = Channels.newChannel(buffer);

            publisher.subscribe(byteBuffer -> {
                while (byteBuffer.hasRemaining()) {
                    try {
                        channel.write(byteBuffer);
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
            }).join();

            channel.close();

            // 将缓冲区内容写入ZIP
            buffer.writeTo(zipOut);
            zipOut.closeEntry();

        } catch (Exception e) {
            throw new IOException("添加文件到ZIP失败: " + objectKey, e);
        }
    }

    /**
     * 删除指定前缀下的所有对象(辅助方法)
     *
     * @param prefix 目录前缀
     * @return 删除的对象数量
     */
    private int deleteAllObjectsUnderPrefix(String prefix) {
        int deletedCount = 0;
        String continuationToken = null;

        try {
            do {
                // 构建列表请求
                ListObjectsV2Request.Builder requestBuilder = ListObjectsV2Request.builder()
                    .bucket(properties.getBucketName())
                    .prefix(prefix)
                    .maxKeys(1000); // 每批最多1000个

                if (continuationToken != null) {
                    requestBuilder.continuationToken(continuationToken);
                }

                ListObjectsV2Response response = client.listObjectsV2(requestBuilder.build()).join();

                List<S3Object> contents = response.contents();

                if (!contents.isEmpty()) {
                    // 批量删除当前批次的对象
                    List<ObjectIdentifier> objectsToDelete = contents.stream()
                        .map(s3Object -> ObjectIdentifier.builder()
                            .key(s3Object.key())
                            .build())
                        .toList();

                    DeleteObjectsRequest deleteRequest = DeleteObjectsRequest.builder()
                        .bucket(properties.getBucketName())
                        .delete(Delete.builder()
                            .objects(objectsToDelete)
                            .quiet(true) // 静默模式,不返回成功删除的对象列表
                            .build())
                        .build();

                    DeleteObjectsResponse deleteResponse = client.deleteObjects(deleteRequest).join();

                    int batchDeletedCount = objectsToDelete.size() - deleteResponse.errors().size();
                    deletedCount += batchDeletedCount;

                    // 记录删除错误
                    if (!deleteResponse.errors().isEmpty()) {
                        for (S3Error error : deleteResponse.errors()) {
                            log.error("删除对象失败: {}, 错误: {}", error.key(), error.message());
                        }
                    }

                    log.debug("批次删除完成,本批删除 {} 个对象", batchDeletedCount);
                }

                // 检查是否还有更多对象
                if (response.isTruncated()) {
                    continuationToken = response.nextContinuationToken();
                } else {
                    continuationToken = null;
                }

            } while (continuationToken != null);

        } catch (Exception e) {
            throw new OssException("删除目录内容失败: " + e.getMessage());
        }

        return deletedCount;
    }

    /**
     * 批量删除多个文件(辅助方法)
     * 使用S3的批量删除API,最多每批1000个
     *
     * @param fileKeys 文件key列表
     * @return 删除的文件数量
     */
    private int batchDeleteFiles(List<String> fileKeys) {
        if (fileKeys == null || fileKeys.isEmpty()) {
            return 0;
        }

        int totalDeleted = 0;

        try {
            // 分批删除,每批最多1000个(S3限制)
            int batchSize = 1000;
            for (int i = 0; i < fileKeys.size(); i += batchSize) {
                int end = Math.min(i + batchSize, fileKeys.size());
                List<String> batch = fileKeys.subList(i, end);

                // 构建批量删除请求
                List<ObjectIdentifier> objectsToDelete = batch.stream()
                    .map(key -> ObjectIdentifier.builder()
                        .key(key)
                        .build())
                    .toList();

                DeleteObjectsRequest deleteRequest = DeleteObjectsRequest.builder()
                    .bucket(properties.getBucketName())
                    .delete(Delete.builder()
                        .objects(objectsToDelete)
                        .quiet(true) // 静默模式
                        .build())
                    .build();

                DeleteObjectsResponse deleteResponse = client.deleteObjects(deleteRequest).join();

                int batchDeletedCount = objectsToDelete.size() - deleteResponse.errors().size();
                totalDeleted += batchDeletedCount;

                // 记录删除错误
                if (!deleteResponse.errors().isEmpty()) {
                    for (S3Error error : deleteResponse.errors()) {
                        log.error("删除文件失败: {}, 错误: {}", error.key(), error.message());
                    }
                }

                log.debug("批次删除文件完成,本批删除 {} 个文件", batchDeletedCount);
            }

        } catch (Exception e) {
            throw new OssException("批量删除文件失败: " + e.getMessage());
        }

        return totalDeleted;
    }

    /**
     * 规范化路径用于比较(辅助方法)
     * 统一处理路径格式,便于后续去重比较
     *
     * @param path 原始路径
     * @return 规范化后的路径
     */
    private String normalizePathForComparison(String path) {
        if (path == null || path.isEmpty()) {
            return "";
        }

        String normalized = path.trim();

        // 去掉开头的所有"/"
        while (normalized.startsWith("/")) {
            normalized = normalized.substring(1);
        }

        // 去掉结尾的所有"/"
        while (normalized.endsWith("/")) {
            normalized = normalized.substring(0, normalized.length() - 1);
        }

        return normalized;
    }

    /**
     * 智能过滤冗余路径(辅助方法)
     * 移除被父路径包含的子路径,避免重复删除
     *
     * @param paths 规范化后的路径列表
     * @return 过滤后的路径列表
     */
    private List<String> filterRedundantPaths(List<String> paths) {
        if (paths == null || paths.size() <= 1) {
            return paths;
        }

        // 按路径长度排序,短路径在前(父路径通常更短)
        List<String> sortedPaths = new java.util.ArrayList<>(paths);
        sortedPaths.sort(java.util.Comparator.comparingInt(String::length));

        List<String> result = new java.util.ArrayList<>();

        for (String currentPath : sortedPaths) {
            boolean isRedundant = false;

            // 检查当前路径是否被已添加的任何路径包含
            for (String existingPath : result) {
                if (isPathContainedBy(currentPath, existingPath)) {
                    isRedundant = true;
                    log.debug("路径 [{}] 被父路径 [{}] 包含,已过滤", currentPath, existingPath);
                    break;
                }
            }

            if (!isRedundant) {
                result.add(currentPath);
            }
        }

        return result;
    }

    /**
     * 判断路径A是否被路径B包含(辅助方法)
     *
     * @param pathA 待检查的路径
     * @param pathB 父路径候选
     * @return true-pathA被pathB包含, false-不包含
     */
    private boolean isPathContainedBy(String pathA, String pathB) {
        if (pathA.equals(pathB)) {
            return false; // 相同路径不算包含
        }

        // pathB必须是pathA的前缀,且后面紧跟"/"或pathA刚好等于pathB
        return pathA.startsWith(pathB + "/") || pathA.equals(pathB);
    }

    // ==================== 业务方法 ====================

    /**
     * 上传单个文件(InputStream方式)到指定路径
     * 重写版本：不依赖现有upload方法，直接使用S3AsyncClient
     */
    public void uploadSingleFile(InputStream inputStream, String targetPath, Long length, String contentType) {
        try {
            // 规范化路径
            String normalizedPath = normalizeFilePath(targetPath);

            // 检查目标路径是否已存在同名文件
            if (checkFileExists(normalizedPath)) {
                normalizedPath = addRandomSuffix(normalizedPath, true);
                log.info("目标路径已存在同名文件，自动重命名为: {}", normalizedPath);
            }

            // 将输入流转换为字节数组（确保可重复读取）
            byte[] fileBytes;
            if (inputStream instanceof ByteArrayInputStream) {
                fileBytes = IoUtil.readBytes(inputStream);
            } else {
                fileBytes = IoUtil.readBytes(inputStream);
            }

            // 计算实际长度
            long actualLength = (length != null && length > 0) ? length : fileBytes.length;

            // 创建异步请求体
            BlockingInputStreamAsyncRequestBody requestBody = BlockingInputStreamAsyncRequestBody.builder()
                .contentLength(actualLength)
                .subscribeTimeout(Duration.ofSeconds(120))
                .build();

            // 构建PutObject请求
            PutObjectRequest putRequest = PutObjectRequest.builder()
                .bucket(properties.getBucketName())
                .key(normalizedPath)
                .contentType(contentType != null ? contentType : "application/octet-stream")
                .contentLength(actualLength)
                .build();

            // 执行异步上传
            var putObjectFuture = client.putObject(putRequest, requestBody);

            // 异步写入数据
            requestBody.writeInputStream(new ByteArrayInputStream(fileBytes));

            // 等待上传完成并获取响应
            PutObjectResponse response = putObjectFuture.join();

            // 获取ETag
            String eTag = response.eTag().replace("\"", "");

            log.info("文件上传成功: {}, ETag: {}", normalizedPath, eTag);

        } catch (Exception e) {
            log.error("上传文件失败: {}", targetPath, e);
            if (e instanceof OssException) {
                throw e;
            }
            throw new OssException("上传文件失败:[" + e.getMessage() + "]");
        } finally {
            // 关闭输入流
            try {
                if (inputStream != null) {
                    inputStream.close();
                }
            } catch (IOException e) {
                log.warn("关闭输入流失败", e);
            }
        }
    }

    /**
     * 上传ZIP文件流并解压到指定目录（自动处理同名文件和目录冲突）
     */
    public String uploadMultipleFile(String targetPath, InputStream zipInputStream) {
        ZipInputStream zis = null;
        java.util.Set<String> directories = new java.util.HashSet<>();

        try {
            String basePath = normalizeDirectoryPath(targetPath);

            zis = new ZipInputStream(zipInputStream);
            ZipEntry entry;

            java.util.Map<String, byte[]> allEntries = new java.util.LinkedHashMap<>();

            while ((entry = zis.getNextEntry()) != null) {
                if (entry.isDirectory()) {
                    zis.closeEntry();
                    continue;
                }

                String fileName = entry.getName();
                if (fileName.contains("__MACOSX") || fileName.startsWith("._")) {
                    zis.closeEntry();
                    continue;
                }

                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                byte[] buffer = new byte[8192];
                int len;
                while ((len = zis.read(buffer)) > 0) {
                    baos.write(buffer, 0, len);
                }

                allEntries.put(fileName, baos.toByteArray());
                zis.closeEntry();
            }

            java.util.Map<String, String> pathMapping = new java.util.HashMap<>();

            int uploadCount = 0;
            for (java.util.Map.Entry<String, byte[]> entryData : allEntries.entrySet()) {
                String originalPath = entryData.getKey();
                byte[] fileData = entryData.getValue();

                String resolvedPath = resolvePathConflicts(basePath, originalPath, pathMapping);
                String objectKey = basePath + resolvedPath;

                collectAllParentDirectories(objectKey, directories);

                String contentType = getContentTypeFromFileName(originalPath);
                upload(new ByteArrayInputStream(fileData), objectKey, (long) fileData.length, contentType);

                uploadCount++;
                log.debug("文件上传成功: {}", objectKey);
            }

            int placeholderCount = createPlaceholdersForDirectories(directories);

            log.info("目录上传完成，共上传 {} 个文件, 创建 {} 个占位文件到: {}",
                uploadCount, placeholderCount, targetPath);

            return "上传成功，共 " + uploadCount + " 个文件";

        } catch (Exception e) {
            throw new OssException("上传目录失败:[" + e.getMessage() + "]");
        } finally {
            if (zis != null) {
                try {
                    zis.close();
                } catch (IOException e) {
                    log.error("关闭ZIP输入流失败", e);
                }
            }
        }
    }

    /**
     * 创建目录（通过创建占位文件实现，多级目录每层都创建占位文件）
     */
    public void createDirectory(String path) {
        try {
            String normalized = normalizeDirectoryPath(path);

            if (normalized.isEmpty()) {
                throw new OssException("目录路径不能为空");
            }

            // 移除结尾的"/"进行分割
            normalized = normalized.substring(0, normalized.length() - 1);

            // 分割路径，为每一层创建占位文件
            String[] parts = normalized.split("/");
            StringBuilder currentPath = new StringBuilder();

            int createdCount = 0;
            for (String part : parts) {
                if (!currentPath.isEmpty()) {
                    currentPath.append("/");
                }
                currentPath.append(part);

                log.debug("创建目录层级: [{}]", currentPath);
                createPlaceholderFile(currentPath.toString());
                createdCount++;
            }

            log.info("目录创建成功: [{}]，共创建 {} 层目录", path, createdCount);

        } catch (Exception e) {
            log.error("创建目录失败: [{}], 错误: {}", path, e.getMessage(), e);
            throw new OssException("创建目录失败:[" + e.getMessage() + "]");
        }
    }

    /**
     * 查询指定目录下的内容（过滤占位文件）
     */
    public JSONObject listDirectory(String path) {
        try {
            String prefix = normalizeDirectoryPath(path);

            ListObjectsV2Request request = ListObjectsV2Request.builder()
                .bucket(properties.getBucketName())
                .prefix(prefix)
                .delimiter("/")
                .build();

            ListObjectsV2Response listObjectsV2Response = client.listObjectsV2(request).join();

            final String currentPrefix = prefix;

            return JSONObject.of(
                "parentKey", ("/" + path).replaceFirst("//+", "/").replaceFirst("(.*/)[^/]+/?$", "$1"),
                "currentKey", path.endsWith("/") ? path : path + "/",
                "folders", listObjectsV2Response.commonPrefixes().stream()
                    .map(commonPrefix -> JSONObject.of(
                        "key", "/" + commonPrefix.prefix(),
                        "name", ("/" + commonPrefix.prefix()).replaceAll("/+$", "").replaceAll(".*/", "")
                    ))
                    .toList(),
                "files", listObjectsV2Response.contents().stream()
                    .filter(s3Object -> !s3Object.key().endsWith("/"))
                    .filter(s3Object -> !s3Object.key().endsWith("/" + EMPTY_DIR_PLACEHOLDER))
                    .filter(s3Object -> !s3Object.key().equals(currentPrefix))
                    .map(s3Object -> JSONObject.of(
                        "key", "/" + s3Object.key(),
                        "name", ("/" + s3Object.key()).replaceAll("/+$", "").replaceAll(".*/", ""),
                        "lastModified", s3Object.lastModified()
                            .atZone(ZoneId.of("Asia/Shanghai"))
                            .truncatedTo(ChronoUnit.SECONDS)
                            .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                        "tag", s3Object.eTag().replace("\"", ""),
                        "size", s3Object.size()
                    ))
                    .toList()
            );

        } catch (Exception e) {
            throw new OssException("查询目录内容失败:[" + e.getMessage() + "]");
        }
    }

    /**
     * 判断指定目录是否存在
     */
    public boolean existsDirectory(String path) {
        try {
            String directoryPath = normalizeDirectoryPath(path);

            ListObjectsV2Request request = ListObjectsV2Request.builder()
                .bucket(properties.getBucketName())
                .prefix(directoryPath)
                .maxKeys(1)
                .build();

            ListObjectsV2Response response = client.listObjectsV2(request).join();

            boolean exists = !response.contents().isEmpty() || !response.commonPrefixes().isEmpty();
            log.debug("目录 {} 存在性检查结果: {}", path, exists);
            return exists;

        } catch (Exception e) {
            throw new OssException("检查目录是否存在失败:[" + e.getMessage() + "]");
        }
    }

    /**
     * 下载单个文件或目录到输出流(目录会自动打包成ZIP)
     *
     * @param path         文件或目录路径
     * @param outputStream 输出流
     * @throws OssException 如果下载失败
     */
    public void downloadSingleFile(String path, OutputStream outputStream) {
        try {
            // 先尝试作为文件处理
            String normalizedFilePath = normalizeFilePath(path);

            // 检查是否是文件
            if (checkFileExists(normalizedFilePath)) {
                // 是文件,直接下载
                downloadFileToStream(normalizedFilePath, outputStream);
                log.info("文件下载成功: {}", path);
                return;
            }

            // 不是文件,检查是否是目录
            if (existsDirectory(path)) {
                // 是目录,打包成ZIP下载
                downloadDirectoryAsZipInternal(path, outputStream);
                log.info("目录打包下载成功: {}", path);
                return;
            }

            // 既不是文件也不是目录
            throw new OssException("路径不存在: " + path);

        } catch (Exception e) {
            log.error("下载失败: {}", path, e);
            throw new OssException("下载失败:[" + e.getMessage() + "]");
        }
    }

    /**
     * 批量下载多个文件和目录,打包成ZIP输出(智能去重,保持相对目录结构)
     *
     * @param paths        文件或目录路径列表
     * @param outputStream 输出流
     * @throws OssException 如果下载失败
     */
    public void downloadMultipleFile(List<String> paths, OutputStream outputStream) {
        if (paths == null || paths.isEmpty()) {
            throw new OssException("路径列表不能为空");
        }

        ZipOutputStream zipOut = null;
        try {
            // 第一步: 规范化所有路径并去除完全重复的路径
            java.util.Set<String> normalizedPathSet = new java.util.LinkedHashSet<>();
            for (String path : paths) {
                String normalized = normalizePathForComparison(path);
                if (!normalized.isEmpty()) {
                    normalizedPathSet.add(normalized);
                }
            }

            // 第二步: 智能过滤,移除被父路径包含的子路径
            List<String> filteredPaths = filterRedundantPaths(new java.util.ArrayList<>(normalizedPathSet));

            log.info("原始路径数: {}, 去重后路径数: {}", paths.size(), filteredPaths.size());

            zipOut = new ZipOutputStream(outputStream);

            // 用于跟踪已添加的ZIP条目,防止重复
            java.util.Set<String> addedZipEntries = new java.util.HashSet<>();

            // 用于处理同名文件/目录冲突
            java.util.Map<String, Integer> nameCountMap = new java.util.HashMap<>();

            int totalCount = 0;

            for (String path : filteredPaths) {
                // 规范化路径
                String normalizedPath = normalizePathForComparison(path);

                // 检查是文件还是目录
                if (checkFileExists(normalizedPath)) {
                    // 是文件,提取文件名作为ZIP中的顶层文件名
                    String fileName = extractFileName(normalizedPath);
                    String uniqueFileName = generateUniqueNameInZip(fileName, nameCountMap);

                    if (!addedZipEntries.contains(uniqueFileName)) {
                        addSingleFileToZip(normalizedPath, uniqueFileName, zipOut);
                        addedZipEntries.add(uniqueFileName);
                        totalCount++;
                        log.debug("已添加文件到ZIP: {}", uniqueFileName);
                    } else {
                        log.warn("ZIP条目已存在，跳过: {}", uniqueFileName);
                    }

                } else if (existsDirectory(path)) {
                    // 是目录,提取目录名作为ZIP中的顶层目录
                    String dirName = extractTopLevelDirName(path);
                    String uniqueDirName = generateUniqueNameInZip(dirName, nameCountMap);

                    String prefix = normalizeDirectoryPath(path);

                    // 关键：传入目录的prefix和uniqueDirName作为ZIP基础路径
                    int fileCount = addDirectoryFilesToZipWithBasePath(prefix, prefix, uniqueDirName, zipOut, addedZipEntries);
                    totalCount += fileCount;
                    log.debug("已添加目录到ZIP: {}, 包含 {} 个文件", uniqueDirName, fileCount);

                } else {
                    log.warn("路径不存在,跳过: {}", path);
                }
            }

            zipOut.finish();
            log.info("批量下载完成,共打包 {} 个文件", totalCount);

        } catch (Exception e) {
            log.error("批量下载失败", e);
            throw new OssException("批量下载失败:[" + e.getMessage() + "]");
        } finally {
            if (zipOut != null) {
                try {
                    zipOut.close();
                } catch (IOException e) {
                    log.error("关闭ZIP输出流失败", e);
                }
            }
        }
    }

    /**
     * 删除单个文件或目录
     *
     * @param path 文件或目录路径
     * @throws OssException 如果删除失败
     */
    public void deleteSingleFile(String path) {
        try {
            String normalizedPath = normalizePathForComparison(path);

            if (normalizedPath.isEmpty()) {
                throw new OssException("路径不能为空");
            }

            // 检查是文件还是目录
            boolean isFile = checkFileExists(normalizedPath);
            boolean isDirectory = !isFile && existsDirectory(path);

            if (!isFile && !isDirectory) {
                throw new OssException("路径不存在: " + path);
            }

            if (isFile) {
                // 删除文件
                client.deleteObject(
                    x -> x.bucket(properties.getBucketName())
                        .key(normalizedPath)
                        .build()
                ).join();

                log.info("文件删除成功: {}", path);
            } else {
                // 删除目录及其所有内容
                String directoryPrefix = normalizeDirectoryPath(path);
                int deletedCount = deleteAllObjectsUnderPrefix(directoryPrefix);

                log.info("目录删除成功: {}, 共删除 {} 个对象", path, deletedCount);
            }

        } catch (Exception e) {
            log.error("删除失败: {}", path, e);
            if (e instanceof OssException) {
                throw e;
            }
            throw new OssException("删除失败:[" + e.getMessage() + "]");
        }
    }

    /**
     * 批量删除多个文件和目录(智能去重,避免重复删除)
     *
     * @param paths 文件或目录路径列表
     * @throws OssException 如果删除失败
     */
    public void deleteMultipleFiles(List<String> paths) {
        if (paths == null || paths.isEmpty()) {
            throw new OssException("路径列表不能为空");
        }

        try {
            // 第一步: 规范化所有路径并去除完全重复的路径
            java.util.Set<String> normalizedPathSet = new java.util.LinkedHashSet<>();
            for (String path : paths) {
                String normalized = normalizePathForComparison(path);
                if (!normalized.isEmpty()) {
                    normalizedPathSet.add(normalized);
                }
            }

            // 第二步: 智能过滤,移除被父路径包含的子路径
            List<String> filteredPaths = filterRedundantPaths(new java.util.ArrayList<>(normalizedPathSet));

            log.info("原始路径数: {}, 去重后路径数: {}", paths.size(), filteredPaths.size());

            // 第三步: 分类路径为文件和目录
            List<String> filesToDelete = new java.util.ArrayList<>();
            List<String> directoriesToDelete = new java.util.ArrayList<>();

            for (String path : filteredPaths) {
                String normalizedPath = normalizePathForComparison(path);

                if (checkFileExists(normalizedPath)) {
                    filesToDelete.add(normalizedPath);
                } else if (existsDirectory(path)) {
                    directoriesToDelete.add(normalizeDirectoryPath(path));
                } else {
                    log.warn("路径不存在,跳过: {}", path);
                }
            }

            int totalDeletedCount = 0;

            // 第四步: 批量删除文件
            if (!filesToDelete.isEmpty()) {
                int fileCount = batchDeleteFiles(filesToDelete);
                totalDeletedCount += fileCount;
                log.info("批量删除文件完成,共删除 {} 个文件", fileCount);
            }

            // 第五步: 删除目录及其内容
            if (!directoriesToDelete.isEmpty()) {
                for (String dirPrefix : directoriesToDelete) {
                    int dirCount = deleteAllObjectsUnderPrefix(dirPrefix);
                    totalDeletedCount += dirCount;
                    log.debug("目录删除完成: {}, 共删除 {} 个对象", dirPrefix, dirCount);
                }
                log.info("批量删除目录完成,共删除 {} 个目录", directoriesToDelete.size());
            }

            log.info("批量删除总计完成,共删除 {} 个对象", totalDeletedCount);

        } catch (Exception e) {
            log.error("批量删除失败", e);
            if (e instanceof OssException) {
                throw e;
            }
            throw new OssException("批量删除失败:[" + e.getMessage() + "]");
        }
    }

    /**
     * 移动文件或目录到目标目录（处理同名冲突）
     */
    public int moveDirectory(String sourcePath, String targetPath) {
        try {
            String sourceNormalized = normalizeFilePath(sourcePath);
            if (sourceNormalized.endsWith("/")) {
                sourceNormalized = sourceNormalized.substring(0, sourceNormalized.length() - 1);
            }

            String targetNormalized = normalizeDirectoryPath(targetPath);

            if (!existsDirectory(targetPath)) {
                throw new OssException("目标目录不存在: " + targetPath);
            }

            boolean isSourceFile = checkFileExists(sourceNormalized);
            boolean isSourceDir = !isSourceFile && existsDirectory(sourcePath);

            if (!isSourceFile && !isSourceDir) {
                throw new OssException("源路径不存在: " + sourcePath);
            }

            int movedCount = isSourceFile
                ? moveSingleFile(sourceNormalized, targetNormalized)
                : moveEntireDirectory(sourceNormalized, targetNormalized);

            log.info("移动成功，共移动 {} 个文件", movedCount);
            return movedCount;

        } catch (Exception e) {
            if (e instanceof OssException) {
                throw e;
            }
            throw new OssException("移动失败:[" + e.getMessage() + "]");
        }
    }

}
