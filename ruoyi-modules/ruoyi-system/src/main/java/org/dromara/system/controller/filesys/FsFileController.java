package org.dromara.system.controller.filesys;

import cn.dev33.satoken.annotation.SaCheckRole;
import cn.dev33.satoken.annotation.SaMode;
import com.alibaba.fastjson2.JSONObject;
import lombok.RequiredArgsConstructor;
import org.dromara.common.core.utils.StringUtils;
import org.dromara.system.service.FsFileService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 文件存储
 *
 * @author AntonyCheng
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/filesys")
public class FsFileController {

    private final FsFileService fileService;

    /**
     * 获取当前用户文件列表
     */
    @GetMapping("/user/list")
    @SaCheckRole(value = {"superadmin", "subadmin", "common"}, mode = SaMode.OR)
    public JSONObject userList(@RequestParam(required = false, value = "path") String path) {
        if (StringUtils.isNotBlank(path)) {
            if (path.startsWith("/")) {
                path = path.substring(1);
            }
            if (path.endsWith("/")) {
                path = path.substring(0, path.length() - 1);
            }
        } else {
            path = "";
        }
        return fileService.selectUserFileList(path);
    }

    /**
     * 获取当前部门文件列表
     */
    @GetMapping("/dept/list")
    @SaCheckRole(value = {"superadmin", "subadmin"}, mode = SaMode.OR)
    public JSONObject deptList(@RequestParam(required = false, value = "path") String path) {
        if (StringUtils.isNotBlank(path)) {
            if (path.startsWith("/")) {
                path = path.substring(1);
            }
            if (path.endsWith("/")) {
                path = path.substring(0, path.length() - 1);
            }
        } else {
            path = "";
        }
        return fileService.selectDeptFileList(path);
    }

}
