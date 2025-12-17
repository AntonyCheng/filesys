package org.dromara.system.service.impl;

import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.dromara.common.core.exception.ServiceException;
import org.dromara.common.core.utils.file.FileUtils;
import org.dromara.common.oss.core.OssClient;
import org.dromara.common.oss.factory.OssFactory;
import org.dromara.common.satoken.utils.LoginHelper;
import org.dromara.system.domain.SysDept;
import org.dromara.system.domain.vo.SysDeptVo;
import org.dromara.system.mapper.SysDeptMapper;
import org.dromara.system.service.FsFileService;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Objects;

/**
 * 文件存储服务实现
 *
 * @author AntonyCheng
 */
@Service
public class FsFileServiceImpl implements FsFileService {

    @Resource
    private SysDeptMapper deptMapper;

    @Override
    public JSONObject selectUserFileList(String path) {
        String userPath = getBaseUserPath();
        String targetPath = userPath + "/" + path;
        JSONObject realRes = OssFactory.instance().listDirectory(targetPath);
        return getFileListRes(userPath, realRes);
    }

    @Override
    public void uploadUserFileSingle(MultipartFile file, String path) {
        String userPath = getBaseUserPath();
        String fileName = StringUtils.isEmpty(file.getOriginalFilename()) ? file.getName() : file.getOriginalFilename();
        try {
            String targetPath = userPath + "/" + path + (StringUtils.isEmpty(path) ? "" : "/") + fileName;
            OssFactory.instance().uploadSingleFile(file.getInputStream(), targetPath, file.getSize(), file.getContentType());
        } catch (IOException e) {
            throw new ServiceException("文件流获取失败");
        }
    }

    @Override
    public void downloadUserFileSingle(String path, HttpServletResponse response) {
        String userPath = getBaseUserPath();
        String targetFile = userPath + "/" + path;
        try {
            String fileName = FilenameUtils.getName(targetFile);
            if (FilenameUtils.getExtension(fileName).isEmpty()) {
                fileName = fileName + ".zip";
            }
            FileUtils.setAttachmentResponseHeader(response, fileName);
            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE + "; charset=UTF-8");
            OssFactory.instance().downloadSingleFile(targetFile, response.getOutputStream());
        } catch (IOException e) {
            throw new ServiceException("输出流获取失败");
        }
    }

    @Override
    public void deleteUserFileSingle(String path) {
        if (Objects.isNull(path) || StringUtils.equals(path, "") || StringUtils.equals(path, "/")) {
            throw new ServiceException("不可删除根路径");
        }
        String userPath = getBaseUserPath();
        OssFactory.instance().deleteSingleFile(userPath + "/" + path);
    }

    @Override
    public void uploadUserFileMultiple(MultipartFile file, String path) {
        String fileName = StringUtils.isEmpty(file.getOriginalFilename()) ? file.getName() : file.getOriginalFilename();
        if (StringUtils.equals(FileUtils.getSuffix(fileName), "zip") && StringUtils.equals(file.getContentType(), "application/zip")) {
            String userPath = getBaseUserPath();
            try {
                OssFactory.instance().uploadMultipleFile(userPath + "/" + path, file.getInputStream());
            } catch (IOException e) {
                throw new ServiceException("文件流获取失败");
            }
        } else {
            throw new ServiceException("文件格式非ZIP文件");
        }
    }

    @Override
    public void downloadUserFileMultiple(List<String> paths, HttpServletResponse response) {
        if (CollectionUtils.isEmpty(paths)) {
            throw new ServiceException("输入路径为空");
        }
        String userPath = getBaseUserPath();
        List<String> targetFiles = paths.stream().map(p -> userPath + "/" + p).toList();
        try {
            String fileName = targetFiles.get(0) + "...等" + targetFiles.size() + "个文件.zip";
            FileUtils.setAttachmentResponseHeader(response, fileName);
            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE + "; charset=UTF-8");
            OssFactory.instance().downloadMultipleFile(targetFiles, response.getOutputStream());
        } catch (IOException e) {
            throw new ServiceException("输出流获取失败");
        }
    }

    @Override
    public void deleteUserFileMultiple(List<String> paths) {
        if (CollectionUtils.isEmpty(paths)) {
            throw new ServiceException("输入路径为空");
        }
        String userPath = getBaseUserPath();
        List<String> targetFiles = paths.stream().peek(p->{
            if (Objects.isNull(p) || StringUtils.equals(p, "") || StringUtils.equals(p, "/")) {
                throw new ServiceException("不可删除根路径");
            }
        }).map(p -> userPath + "/" + p).toList();
        OssFactory.instance().deleteMultipleFiles(targetFiles);
    }

    @Override
    public JSONObject selectDeptFileList(String path) {
        String deptPath = getBaseDeptPath();
        JSONObject realRes = OssFactory.instance().listDirectory(deptPath + "/" + path);
        return getFileListRes(deptPath, realRes);
    }

    private JSONObject getFileListRes(String deptPath, JSONObject realRes) {
        JSONObject res = new JSONObject();
        String parentKey = realRes.getString("parentKey");
        String currentKey = realRes.getString("currentKey");
        JSONArray folders = realRes.getJSONArray("folders");
        JSONArray files = realRes.getJSONArray("files");
        res.put("parentKey", parentKey.length() < deptPath.length() ? null : parentKey.substring(deptPath.length()));
        res.put("currentKey", currentKey.substring(deptPath.length()));
        res.put("currentName", "/".equals(currentKey.substring(deptPath.length())) ? null : currentKey.substring(deptPath.length()).replaceAll("/+$", "").replaceAll(".*/", ""));
        res.put("folders", folders.stream().map(obj -> {
            JSONObject tempObj = (JSONObject) obj;
            tempObj.put("key", tempObj.getString("key").substring(deptPath.length()));
            return tempObj;
        }).toList());
        res.put("files", files.stream().map(obj -> {
            JSONObject tempObj = (JSONObject) obj;
            tempObj.put("key", tempObj.getString("key").substring(deptPath.length()));
            return tempObj;
        }).toList());
        return res;
    }

    private String getBaseUserPath() {
        String res = getBaseDeptPath() + "/" + "user_" + LoginHelper.getUsername();
        OssClient storage = OssFactory.instance();
        if (!storage.existsDirectory(res)) {
            storage.createDirectory(res);
        }
        return res;
    }

    private String getBaseDeptPath() {
        SysDept currentDept = deptMapper.selectById(LoginHelper.getDeptId());
        StringBuilder baseUri = new StringBuilder();
        SysDept topDept = deptMapper.selectOne(
            new LambdaQueryWrapper<SysDept>()
                .eq(SysDept::getParentId, 0)
                .last("limit 1")
        );
        if (Objects.equals(currentDept.getDeptId(), topDept.getDeptId())) {
            baseUri.append("/").append(currentDept.getDeptCategory());
        } else {
            String[] ancestors = currentDept.getAncestors().split(",");
            for (int i = 1; i < ancestors.length; i++) {
                SysDeptVo sysDeptVo = deptMapper.selectVoOne(
                    new LambdaQueryWrapper<SysDept>()
                        .eq(SysDept::getDeptId, ancestors[i])
                );
                baseUri.append("/").append(sysDeptVo.getDeptCategory());
            }
            baseUri.append("/").append(currentDept.getDeptCategory());
        }
        String res = baseUri.toString();
        OssClient storage = OssFactory.instance();
        if (!storage.existsDirectory(res)) {
            storage.createDirectory(res);
        }
        return res;
    }

}
