package org.dromara.system.controller.filesys;

import cn.dev33.satoken.annotation.SaCheckRole;
import cn.dev33.satoken.annotation.SaMode;
import com.alibaba.fastjson2.JSONObject;
import lombok.RequiredArgsConstructor;
import org.dromara.common.core.domain.R;
import org.dromara.common.core.utils.StringUtils;
import org.dromara.common.oss.entity.UploadResult;
import org.dromara.system.service.FsFileService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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
     * 用户获取自己文件列表
     */
    @GetMapping("/user/list")
    @SaCheckRole(value = {"superadmin", "subadmin", "common"}, mode = SaMode.OR)
    public R<JSONObject> userList(@RequestParam(required = false, value = "path") String path) {
        return R.ok(fileService.selectUserFileList(handlePath(path)));
    }

    /**
     * 用户上传单个文件
     */
    @PostMapping("/user/upload/single")
    @SaCheckRole(value = {"superadmin", "subadmin", "common"}, mode = SaMode.OR)
    public R<String> userUploadSingle(@RequestPart("file") MultipartFile file, @RequestParam("path") String path) {
        fileService.uploadUserFileSingle(file, handlePath(path));
        return R.ok("上传成功");
    }

    /**
     * 用户上传多个文件压缩包
     */
    @PostMapping("/user/upload/multiple")
    @SaCheckRole(value = {"superadmin", "subadmin", "common"}, mode = SaMode.OR)
    public R<String> userUploadMultiple(@RequestPart("file") MultipartFile file, @RequestParam("path") String path) {
        fileService.uploadUserFileMultiple(file, handlePath(path));
        return R.ok("上传成功");
    }

    /**
     * 管理员获取当前部门文件列表
     */
    @GetMapping("/dept/list")
    @SaCheckRole(value = {"superadmin", "subadmin"}, mode = SaMode.OR)
    public R<JSONObject> deptList(@RequestParam(required = false, value = "path") String path) {
        return R.ok(fileService.selectDeptFileList(handlePath(path)));
    }

    /**
     * 处理路径
     * 最终输出结果形式：a/b/c
     */
    private String handlePath(String path) {
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
        return path;
    }

}
