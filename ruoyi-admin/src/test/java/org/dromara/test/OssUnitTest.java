package org.dromara.test;

import org.dromara.common.oss.core.OssClient;
import org.dromara.common.oss.factory.OssFactory;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.FileNotFoundException;

/**
 * OSS单元测试案例
 *
 * @author AntonyCheng
 */
@SpringBootTest
@DisplayName("OSS测试案例")
public class OssUnitTest {

    @Test
    public void ossTest() throws FileNotFoundException {
        OssClient storage = OssFactory.instance();
        storage.moveDirectory("/abc/bcd/模型测试图片", "/abc/bcd/logs");
    }

}
