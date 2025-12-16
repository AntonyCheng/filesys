package org.dromara.system.service;


import com.alibaba.fastjson2.JSONObject;
import org.dromara.common.oss.entity.UploadResult;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件存储服务接口
 *
 * @author AntonyCheng
 */
public interface FsFileService {

    JSONObject selectUserFileList(String path);

    void uploadUserFileSingle(MultipartFile file, String path);

    void uploadUserFileMultiple(MultipartFile file, String path);

    JSONObject selectDeptFileList(String path);
}
