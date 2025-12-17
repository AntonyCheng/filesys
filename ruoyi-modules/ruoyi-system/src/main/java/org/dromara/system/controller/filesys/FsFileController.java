package org.dromara.system.controller.filesys;

import cn.dev33.satoken.annotation.SaCheckRole;
import cn.dev33.satoken.annotation.SaMode;
import com.alibaba.fastjson2.JSONObject;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.dromara.common.core.domain.R;
import org.dromara.common.core.utils.StringUtils;
import org.dromara.system.service.FsFileService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

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
    public R<String> userUploadSingle(@RequestPart("file") MultipartFile file, @RequestParam(required = false, value = "path") String path) {
        fileService.uploadUserFileSingle(file, handlePath(path));
        return R.ok("上传成功");
    }

    /**
     * 用户下载单个文件
     */
    @GetMapping("/user/download/single")
    @SaCheckRole(value = {"superadmin", "subadmin", "common"}, mode = SaMode.OR)
    public void userDownloadSingle(@RequestParam("path") String path, HttpServletResponse response) {
        fileService.downloadUserFileSingle(handlePath(path), response);
    }

    /**
     * 用户删除单个文件
     */
    @PostMapping("/user/delete/single")
    @SaCheckRole(value = {"superadmin", "subadmin", "common"}, mode = SaMode.OR)
    public R<String> userDeleteSingle(@RequestParam(required = false, value = "path") String path){
        fileService.deleteUserFileSingle(handlePath(path));
        return R.ok("删除成功");
    }

    /**
     * 用户上传多个文件压缩包
     */
    @PostMapping("/user/upload/multiple")
    @SaCheckRole(value = {"superadmin", "subadmin", "common"}, mode = SaMode.OR)
    public R<String> userUploadMultiple(@RequestPart("file") MultipartFile file, @RequestParam(required = false, value = "path") String path) {
        fileService.uploadUserFileMultiple(file, handlePath(path));
        return R.ok("上传成功");
    }

    /**
     * 用户下载多个文件到压缩包
     */
    @GetMapping("/user/download/multiple")
    @SaCheckRole(value = {"superadmin", "subadmin", "common"}, mode = SaMode.OR)
    public void userDownloadMultiple(@RequestParam("paths") List<String> paths, HttpServletResponse response) {
        fileService.downloadUserFileMultiple(handlePaths(paths), response);
    }

    /**
     * 用户删除多个文件
     */
    @PostMapping("/user/delete/multiple")
    @SaCheckRole(value = {"superadmin", "subadmin", "common"}, mode = SaMode.OR)
    public R<String> userDeleteMultiple(@RequestParam("paths") List<String> paths){
        fileService.deleteUserFileMultiple(handlePaths(paths));
        return R.ok("删除成功");
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
     * 处理多个路径
     * 最终输出结果形式：a/b/c
     */
    private List<String> handlePaths(List<String> paths) {
        List<String> pathsRes = new ArrayList<>();
        for (String path : paths) {
            pathsRes.add(handlePath(path));
        }
        return pathsRes;
    }

    /**
     * 处理单个路径
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
