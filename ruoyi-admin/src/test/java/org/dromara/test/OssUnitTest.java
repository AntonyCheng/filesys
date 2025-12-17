package org.dromara.test;

import org.apache.commons.lang3.StringUtils;
import org.dromara.common.oss.core.OssClient;
import org.dromara.common.oss.factory.OssFactory;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

/**
 * OSS单元测试案例
 *
 * @author AntonyCheng
 */
@SpringBootTest
@DisplayName("OSS测试案例")
public class OssUnitTest {

    @Test
    public void ossTest() throws IOException {
        OssClient storage = OssFactory.instance();

        // 创建目录
        if (!storage.existsDirectory("/ljch/user_admin")) {
            storage.createDirectory("/ljch/user_admin");
        }

        // 上传单个文件
        MockMultipartFile file = new MockMultipartFile("README.md", new FileInputStream("D:\\Desktop\\unicom-project\\fileSys\\README.md"));
        String originalFileName = StringUtils.isEmpty(file.getOriginalFilename()) ? file.getName() : file.getOriginalFilename();
        storage.uploadSingleFile(file.getInputStream(), "/ljch/user_admin/" + originalFileName, file.getSize(), file.getContentType());

        // 上传文件夹或者多个文件
        storage.uploadMultipleFile("/ljch/user_admin", new FileInputStream("D:\\Desktop\\unicom-project\\fileSys\\script.zip"));

        // 下载整个目录
//        storage.downloadDirectoryAsZip("/ljch/user_admin", new FileOutputStream("D:\\Desktop\\unicom-project\\fileSys\\download.zip"));

        // 删除单个文件
        storage.deleteSingleFile("/ljch/user_admin/README.md");

        // 删除多个文件
        storage.deleteMultipleFiles(List.of("/ljch/user_admin/script/bin/ry.bat", "/ljch/user_admin/script/docker/database.yml"));

        // 删除目录
//        storage.deleteDirectory("/ljch/user_admin/script/sql");

        // 移动文件或者目录
        storage.moveDirectory("/ljch/user_admin/script/leave/leave1.json", "/ljch/user_admin");
        storage.moveDirectory("/ljch/user_admin/script/leave", "/ljch/user_admin");

    }

}
