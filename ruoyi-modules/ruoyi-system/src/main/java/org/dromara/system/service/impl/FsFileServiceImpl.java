package org.dromara.system.service.impl;

import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.dromara.common.core.exception.ServiceException;
import org.dromara.common.oss.core.OssClient;
import org.dromara.common.oss.factory.OssFactory;
import org.dromara.common.satoken.utils.LoginHelper;
import org.dromara.system.domain.SysDept;
import org.dromara.system.domain.vo.SysDeptVo;
import org.dromara.system.mapper.SysDeptMapper;
import org.dromara.system.service.FsFileService;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
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
        JSONObject res = new JSONObject();
        String parentKey = realRes.getString("parentKey");
        String currentKey = realRes.getString("currentKey");
        JSONArray folders = realRes.getJSONArray("folders");
        JSONArray files = realRes.getJSONArray("files");
        res.put("parentKey", parentKey.length() < userPath.length() ? null : parentKey.substring(userPath.length()));
        res.put("currentKey", currentKey.substring(userPath.length()));
        res.put("currentName", "/".equals(currentKey.substring(userPath.length())) ? null : currentKey.substring(userPath.length()).replaceAll("/+$", "").replaceAll(".*/", ""));
        res.put("folders", folders.stream().map(obj -> {
            JSONObject tempObj = (JSONObject) obj;
            tempObj.put("key", tempObj.getString("key").substring(userPath.length()));
            return tempObj;
        }).toList());
        res.put("files", files.stream().map(obj -> {
            JSONObject tempObj = (JSONObject) obj;
            tempObj.put("key", tempObj.getString("key").substring(userPath.length()));
            return tempObj;
        }).toList());
        return res;
    }

    @Override
    public void uploadUserFileSingle(MultipartFile file, String path) {
        String userPath = getBaseUserPath();
        String originalFileName = StringUtils.isEmpty(file.getOriginalFilename()) ? file.getName() : file.getOriginalFilename();
        try {
            String targetPath = userPath + "/" + path + (StringUtils.isEmpty(path) ? "" : "/") + originalFileName;
            OssFactory.instance().uploadSingleFile(file.getInputStream(), targetPath, file.getSize(), file.getContentType());
        } catch (IOException e) {
            throw new ServiceException("文件流获取失败");
        }
    }

    @Override
    public void uploadUserFileMultiple(MultipartFile file, String path) {
        String userPath = getBaseUserPath();
        try {
            OssFactory.instance().uploadDirectoryFromZip(userPath + "/" + path, file.getInputStream());
        } catch (IOException e) {
            throw new ServiceException("文件流获取失败");
        }
    }

    @Override
    public JSONObject selectDeptFileList(String path) {
        String deptPath = getBaseDeptPath();
        JSONObject realRes = OssFactory.instance().listDirectory(deptPath + "/" + path);
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
        if (!storage.directoryExists(res)) {
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
        if (!storage.directoryExists(res)) {
            storage.createDirectory(res);
        }
        return res;
    }

}
