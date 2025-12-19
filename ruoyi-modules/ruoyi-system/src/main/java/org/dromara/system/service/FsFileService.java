package org.dromara.system.service;


import com.alibaba.fastjson2.JSONObject;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 文件存储服务接口
 *
 * @author AntonyCheng
 */
public interface FsFileService {

    JSONObject selectUserFileList(String path);

    void createUserDirectory(String path);

    void uploadUserFileSingle(MultipartFile file, String path);

    void downloadUserFileSingle(String path, HttpServletResponse response);

    void deleteUserFileSingle(String path);

    void uploadUserFileMultiple(MultipartFile file, String path);

    void downloadUserFileMultiple(List<String> paths, HttpServletResponse response);

    void deleteUserFileMultiple(List<String> paths);

    JSONObject selectDeptFileList(String path);
}
