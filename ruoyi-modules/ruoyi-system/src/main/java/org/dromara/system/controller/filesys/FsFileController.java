package org.dromara.system.controller.filesys;

import com.alibaba.fastjson2.JSONObject;
import lombok.RequiredArgsConstructor;
import org.dromara.system.service.FsFileService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 文件存储
 *
 * @author AntonyCheng
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/filesys/file")
public class FsFileController {

    private final FsFileService fileService;

    /**
     * 获取该用户文件列表
     */
    @GetMapping("/list")
    public JSONObject list() {
        return fileService.selectPageFileList();
    }

}
