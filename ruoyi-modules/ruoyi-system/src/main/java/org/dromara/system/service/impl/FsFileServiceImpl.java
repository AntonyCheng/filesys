package org.dromara.system.service.impl;

import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import org.dromara.common.oss.core.OssClient;
import org.dromara.common.oss.factory.OssFactory;
import org.dromara.common.satoken.utils.LoginHelper;
import org.dromara.system.domain.SysDept;
import org.dromara.system.domain.vo.SysDeptVo;
import org.dromara.system.mapper.SysDeptMapper;
import org.dromara.system.service.FsFileService;
import org.springframework.stereotype.Service;

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
    public JSONObject selectPageFileList() {
        SysDept sysDept = deptMapper.selectById(LoginHelper.getDeptId());
        String[] father = sysDept.getAncestors().split(",");
        String baseUri = "";
        for (String s : father) {
            SysDeptVo sysDeptVo = deptMapper.selectVoOne(
                new LambdaQueryWrapper<SysDept>()
                    .eq(SysDept::getParentId, s)
            );
            baseUri = "/" + sysDeptVo.getDeptCategory();
        }


        OssClient storage = OssFactory.instance();
        storage.listDirectory(baseUri);

        return null;
    }

}
