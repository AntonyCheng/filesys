package org.dromara.system.service;


import com.alibaba.fastjson2.JSONObject;

/**
 * 文件存储服务接口
 *
 * @author AntonyCheng
 */
public interface FsFileService {

    JSONObject selectUserFileList(String path);

    JSONObject selectDeptFileList(String path);

}
