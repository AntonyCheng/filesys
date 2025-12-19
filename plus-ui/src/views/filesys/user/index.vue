<template>
  <div class="app-container">
    <!-- 面包屑导航 -->
    <el-breadcrumb separator="/" class="breadcrumb">
      <el-breadcrumb-item>
        <el-link :underline="false" @click="navigateTo('')">根目录</el-link>
      </el-breadcrumb-item>
      <el-breadcrumb-item v-for="(item, index) in breadcrumbList" :key="index">
        <el-link :underline="false" @click="navigateTo(item.path)">
          {{ item.name }}
        </el-link>
      </el-breadcrumb-item>
    </el-breadcrumb>

    <!-- 操作栏 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          icon="Back"
          @click="goBack"
          :disabled="!fileListData?.parentKey"
        >
          返回上一级
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="info" icon="FolderAdd" @click="handleCreateFolder">
          创建文件夹
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="primary" icon="Upload" @click="handleUploadSingle">
          上传文件
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" icon="Upload" @click="handleUploadMultiple">
          上传文件夹
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          icon="Download"
          :disabled="selectedItems.length === 0"
          @click="handleDownload"
        >
          下载
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          icon="Delete"
          :disabled="selectedItems.length === 0"
          @click="handleDelete"
        >
          删除
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button icon="Refresh" @click="refreshList">刷新</el-button>
      </el-col>
    </el-row>

    <!-- 文件列表 -->
    <el-table
      v-loading="loading"
      :data="tableData"
      @selection-change="handleSelectionChange"
      @row-dblclick="handleRowDblClick"
    >
      <el-table-column type="selection" width="55"/>
      <el-table-column label="名称" prop="name" min-width="200">
        <template #default="scope">
          <el-icon v-if="scope.row.type === 'folder'" style="margin-right: 5px">
            <Folder/>
          </el-icon>
          <el-icon v-else style="margin-right: 5px">
            <Document/>
          </el-icon>
          <el-link
            :underline="false"
            @click="handleItemClick(scope.row)"
            style="margin-left: 5px"
          >
            {{ scope.row.name }}
          </el-link>
        </template>
      </el-table-column>
      <el-table-column label="修改时间" prop="lastModified" width="180"/>
      <el-table-column label="大小" prop="sizeStr" width="120"/>
      <el-table-column label="操作" width="220">
        <template #default="scope">
          <el-button
            v-if="scope.row.type === 'file' && canPreviewFile(scope.row.name)"
            link
            type="success"
            icon="View"
            @click="handlePreview(scope.row)"
          >
            点击预览
          </el-button>
          <el-button
            v-else-if="scope.row.type === 'file'"
            link
            type="danger"
            icon="Hide"
            disabled
          >
            暂不支持
          </el-button>
          <el-button
            v-if="scope.row.type === 'file'"
            link
            type="primary"
            icon="Download"
            @click="handleDownloadSingle(scope.row)"
          >
            下载
          </el-button>
          <el-button
            link
            type="danger"
            icon="Delete"
            @click="handleDeleteSingle(scope.row)"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 上传单个文件对话框 -->
    <el-dialog v-model="uploadSingleVisible" title="上传文件" width="500px">
      <el-upload
        ref="uploadSingleRef"
        v-model:file-list="uploadSingleFileList"
        :auto-upload="false"
        :limit="1"
        :on-exceed="handleExceedSingle"
        drag
      >
        <el-icon class="el-icon--upload">
          <upload-filled/>
        </el-icon>
        <div class="el-upload__text">
          拖拽文件到此处或 <em>点击上传</em>
        </div>
      </el-upload>
      <template #footer>
        <el-button @click="uploadSingleVisible = false">取消</el-button>
        <el-button type="primary" @click="submitUploadSingle">确定</el-button>
      </template>
    </el-dialog>

    <!-- 上传文件夹对话框 -->
    <el-dialog v-model="uploadMultipleVisible" title="上传文件/文件夹" width="600px">
      <el-alert
        title="提示"
        type="info"
        description="支持拖拽文件夹到下方区域，或点击按钮选择文件/文件夹，系统会自动打包成ZIP后上传"
        :closable="false"
        style="margin-bottom: 15px"
      />

      <!-- 拖拽上传区域 -->
      <div
        class="upload-drop-zone"
        @drop.prevent="handleDrop"
        @dragover.prevent="dragOver = true"
        @dragleave.prevent="dragOver = false"
        :class="{ 'is-dragover': dragOver }"
      >
        <el-icon class="upload-icon">
          <upload-filled/>
        </el-icon>
        <div class="upload-text">
          拖拽文件或文件夹到此处
        </div>
        <div class="upload-actions">
          <el-button type="primary" @click="triggerFileSelect">选择文件</el-button>
          <el-button type="success" @click="triggerFolderSelect">选择文件夹</el-button>
        </div>
      </div>

      <!-- 隐藏的文件输入 -->
      <input
        ref="fileInputRef"
        type="file"
        multiple
        style="display: none"
        @change="handleFileSelect"
      />
      <input
        ref="folderInputRef"
        type="file"
        webkitdirectory
        directory
        multiple
        style="display: none"
        @change="handleFolderSelect"
      />

      <!-- 已选文件列表 -->
      <div v-if="selectedFiles.length > 0" class="selected-files">
        <div class="selected-files-header">
          <span>已选择 {{ selectedFiles.length }} 个文件</span>
          <el-button link type="danger" @click="clearSelectedFiles">清空</el-button>
        </div>
        <div class="selected-files-list">
          <div v-for="(file, index) in selectedFiles.slice(0, 10)" :key="index" class="file-item">
            <el-icon>
              <Document/>
            </el-icon>
            <span class="file-name">{{ file.path }}</span>
            <span class="file-size">{{ formatFileSize(file.file.size) }}</span>
          </div>
          <div v-if="selectedFiles.length > 10" class="file-item-more">
            还有 {{ selectedFiles.length - 10 }} 个文件...
          </div>
        </div>
      </div>

      <template #footer>
        <el-button @click="uploadMultipleVisible = false">取消</el-button>
        <el-button
          type="primary"
          @click="submitUploadMultiple"
          :loading="uploading"
          :disabled="selectedFiles.length === 0"
        >
          {{ uploading ? '打包上传中...' : `确定上传 (${selectedFiles.length})` }}
        </el-button>
      </template>
    </el-dialog>
    <FilePreview
      v-model="previewVisible"
      :file-key="previewFileKey"
      :file-name="previewFileName"
    />
  </div>
</template>

<script setup lang="ts" name="UserFileIndex">
import FilePreview from '@/components/FilePreview/index.vue';
import {canPreview} from '@/components/FilePreview/utils';
import {computed, onMounted, ref} from 'vue';
import type {UploadInstance, UploadProps, UploadRawFile, UploadUserFile} from 'element-plus';
import {ElMessage, ElMessageBox, genFileId} from 'element-plus';
import {Document, Folder, UploadFilled} from '@element-plus/icons-vue';
import JSZip from 'jszip';
import {
  userCreateDirectory,
  userDeleteMultiple,
  userDeleteSingle,
  userDownloadMultiple,
  userDownloadSingle,
  userList,
  userUploadMultiple,
  userUploadSingle
} from '@/api/filesys/user';
import type {FileList} from '@/api/filesys/types';

// 数据定义
const loading = ref(false);
const uploading = ref(false);
const currentPath = ref('');
const fileListData = ref<FileList | null>(null);
const selectedItems = ref<any[]>([]);
const uploadSingleVisible = ref(false);
const uploadMultipleVisible = ref(false);
const uploadSingleRef = ref<UploadInstance>();
const uploadMultipleRef = ref<UploadInstance>();
const uploadSingleFileList = ref<UploadUserFile[]>([]);
const uploadMultipleFileList = ref<UploadUserFile[]>([]);
const dragOver = ref(false);
const fileInputRef = ref<HTMLInputElement>();
const folderInputRef = ref<HTMLInputElement>();
const selectedFiles = ref<Array<{ file: File; path: string }>>([]);
// 添加预览相关的状态
const previewVisible = ref(false);
const previewFileKey = ref('');
const previewFileName = ref('');

// 判断是否可预览
const canPreviewFile = (fileName: string) => {
  return canPreview(fileName);
};

// 处理预览
const handlePreview = (row: any) => {
  previewFileKey.value = row.key;
  previewFileName.value = row.name;
  previewVisible.value = true;
};
// 表格数据
const tableData = computed(() => {
  if (!fileListData.value) return [];

  const folders = fileListData.value.folders.map(folder => ({
    ...folder,
    type: 'folder',
    lastModified: '-',
    sizeStr: '-'
  }));

  const files = fileListData.value.files.map(file => ({
    ...file,
    type: 'file',
    sizeStr: formatFileSize(file.size)
  }));

  return [...folders, ...files];
});

// 面包屑数据
const breadcrumbList = computed(() => {
  if (!currentPath.value) return [];

  const paths = currentPath.value.split('/').filter(p => p);
  return paths.map((name, index) => ({
    name,
    path: paths.slice(0, index + 1).join('/')
  }));
});

// 格式化文件大小
const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 B';
  const k = 1024;
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
};

// 加载文件列表
const loadFileList = async (path: string = '') => {
  loading.value = true;
  try {
    const {data} = await userList(path);
    fileListData.value = data;
    currentPath.value = path;
  } catch (error) {
    ElMessage.error('加载文件列表失败');
  } finally {
    loading.value = false;
  }
};

// 导航到指定路径
const navigateTo = (path: string) => {
  loadFileList(path);
};

// 返回上一级
const goBack = () => {
  if (fileListData.value?.parentKey) {
    // parentKey 可能是 null 或空字符串，都表示根目录
    const parentPath = fileListData.value.parentKey || '';
    loadFileList(parentPath);
  }
};

// 刷新列表
const refreshList = () => {
  loadFileList(currentPath.value);
};

// 处理选择变化
const handleSelectionChange = (selection: any[]) => {
  selectedItems.value = selection;
};

// 处理行双击
const handleRowDblClick = (row: any) => {
  if (row.type === 'folder') {
    loadFileList(row.key);
  }
};

// 处理项目点击
const handleItemClick = (row: any) => {
  if (row.type === 'folder') {
    loadFileList(row.key);
  }
};

// 创建文件夹
const handleCreateFolder = async () => {
  try {
    const {value} = await ElMessageBox.prompt('请输入文件夹名称', '创建文件夹', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      inputPattern: /^[^\\/:*?"<>|]+$/,
      inputErrorMessage: '文件夹名称不能包含特殊字符'
    });

    const path = currentPath.value ? `${currentPath.value}/${value}` : value;
    await userCreateDirectory(path);
    ElMessage.success('创建成功');
    refreshList();
  } catch (error: any) {
    if (error !== 'cancel') {
      ElMessage.error('创建失败');
    }
  }
};


// 上传单个文件
const handleUploadSingle = () => {
  uploadSingleFileList.value = [];
  uploadSingleVisible.value = true;
};

const submitUploadSingle = async () => {
  if (uploadSingleFileList.value.length === 0) {
    ElMessage.warning('请选择文件');
    return;
  }

  loading.value = true;
  try {
    const file = uploadSingleFileList.value[0].raw as File;
    await userUploadSingle(file, currentPath.value);
    ElMessage.success('上传成功');
    uploadSingleVisible.value = false;
    uploadSingleFileList.value = [];
    refreshList();
  } catch (error) {
    ElMessage.error('上传失败');
  } finally {
    loading.value = false;
  }
};

// 上传文件夹
const handleUploadMultiple = () => {
  selectedFiles.value = [];
  uploadMultipleVisible.value = true;
};

// 触发文件选择
const triggerFileSelect = () => {
  fileInputRef.value?.click();
};

// 触发文件夹选择
const triggerFolderSelect = () => {
  folderInputRef.value?.click();
};

// 处理文件选择
const handleFileSelect = (event: Event) => {
  const input = event.target as HTMLInputElement;
  if (!input.files || input.files.length === 0) return;

  const files = Array.from(input.files);
  files.forEach(file => {
    selectedFiles.value.push({
      file: file,
      path: file.name
    });
  });

  // 清空 input 以便再次选择相同文件
  input.value = '';
};

// 处理文件夹选择
const handleFolderSelect = (event: Event) => {
  const input = event.target as HTMLInputElement;
  if (!input.files || input.files.length === 0) return;

  const files = Array.from(input.files);
  files.forEach(file => {
    // webkitRelativePath 包含相对路径
    const relativePath = (file as any).webkitRelativePath || file.name;
    selectedFiles.value.push({
      file: file,
      path: relativePath
    });
  });

  // 清空 input
  input.value = '';
};

// 处理拖拽放置
const handleDrop = async (event: DragEvent) => {
  dragOver.value = false;

  if (!event.dataTransfer) return;

  const items = event.dataTransfer.items;
  if (!items) return;

  ElMessage.info('正在读取文件...');

  try {
    // 使用 Promise.all 等待所有文件读取完成
    const filePromises: Promise<void>[] = [];

    for (let i = 0; i < items.length; i++) {
      const item = items[i];
      if (item.kind === 'file') {
        const entry = item.webkitGetAsEntry();
        if (entry) {
          filePromises.push(traverseFileTree(entry, ''));
        }
      }
    }

    await Promise.all(filePromises);

    if (selectedFiles.value.length > 0) {
      ElMessage.success(`已添加 ${selectedFiles.value.length} 个文件`);
    }
  } catch (error) {
    console.error('读取文件失败:', error);
    ElMessage.error('读取文件失败');
  }
};

// 递归遍历文件树
const traverseFileTree = async (entry: any, path: string): Promise<void> => {
  return new Promise((resolve, reject) => {
    if (entry.isFile) {
      entry.file((file: File) => {
        const fullPath = path + file.name;
        selectedFiles.value.push({
          file: file,
          path: fullPath
        });
        resolve();
      }, (error: any) => {
        console.error('读取文件失败:', error);
        reject(error);
      });
    } else if (entry.isDirectory) {
      const dirReader = entry.createReader();
      dirReader.readEntries(async (entries: any[]) => {
        try {
          const subPromises = entries.map(subEntry =>
            traverseFileTree(subEntry, path + entry.name + '/')
          );
          await Promise.all(subPromises);
          resolve();
        } catch (error) {
          reject(error);
        }
      }, (error: any) => {
        console.error('读取目录失败:', error);
        reject(error);
      });
    } else {
      resolve();
    }
  });
};

// 清空已选文件
const clearSelectedFiles = () => {
  selectedFiles.value = [];
};

const submitUploadMultiple = async () => {
  if (selectedFiles.value.length === 0) {
    ElMessage.warning('请选择文件或文件夹');
    return;
  }

  uploading.value = true;
  try {
    // 创建 ZIP 实例
    const zip = new JSZip();

    // 统计信息
    let totalSize = 0;

    // 添加所有文件到 ZIP
    for (const item of selectedFiles.value) {
      zip.file(item.path, item.file);
      totalSize += item.file.size;
    }

    ElMessage.info(`正在打包 ${selectedFiles.value.length} 个文件 (${formatFileSize(totalSize)})...`);

    // 生成 ZIP 文件
    const zipBlob = await zip.generateAsync({
      type: 'blob',
      compression: 'DEFLATE',
      compressionOptions: {
        level: 6
      }
    }, (metadata) => {
      const percent = metadata.percent.toFixed(0);
      console.log(`打包进度: ${percent}%`);
    });

    // 创建 File 对象
    const zipFile = new File([zipBlob], 'upload.zip', {type: 'application/zip'});

    ElMessage.info('开始上传...');

    // 上传 ZIP 文件
    await userUploadMultiple(zipFile, currentPath.value);

    ElMessage.success(`上传成功！共 ${selectedFiles.value.length} 个文件`);
    uploadMultipleVisible.value = false;
    selectedFiles.value = [];
    refreshList();
  } catch (error: any) {
    console.error('上传失败:', error);
    ElMessage.error('上传失败: ' + (error.message || '未知错误'));
  } finally {
    uploading.value = false;
  }
};

// 处理文件超出限制 - 单个文件
const handleExceedSingle: UploadProps['onExceed'] = (files) => {
  uploadSingleRef.value!.clearFiles();
  const file = files[0] as UploadRawFile;
  file.uid = genFileId();
  uploadSingleRef.value!.handleStart(file);
};

// 下载单个文件
const handleDownloadSingle = async (row: any) => {
  loading.value = true;
  try {
    // API 返回的直接是 blob 数据（因为 request.ts 中返回了 res.data）
    const blob = await userDownloadSingle(row.key);

    // 检查是否是有效的 blob
    if (!blob || !(blob instanceof Blob)) {
      throw new Error('下载失败：返回数据格式错误');
    }

    // 使用行数据中的文件名
    const fileName = row.name;

    // 创建下载链接
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = fileName;
    link.style.display = 'none';
    document.body.appendChild(link);
    link.click();

    // 清理
    setTimeout(() => {
      document.body.removeChild(link);
      window.URL.revokeObjectURL(url);
    }, 100);

    ElMessage.success('下载成功');
  } catch (error: any) {
    console.error('下载失败:', error);
    ElMessage.error('下载失败：' + (error.message || '未知错误'));
  } finally {
    loading.value = false;
  }
};

// 批量下载
const handleDownload = async () => {
  if (selectedItems.value.length === 0) {
    ElMessage.warning('请选择要下载的文件或文件夹');
    return;
  }

  loading.value = true;
  try {
    const paths = selectedItems.value.map(item => item.key);
    // API 返回的直接是 blob 数据
    const blob = await userDownloadMultiple(paths);

    // 检查是否是有效的 blob
    if (!blob || !(blob instanceof Blob)) {
      throw new Error('下载失败：返回数据格式错误');
    }

    // 生成文件名
    const fileName = selectedItems.value.length === 1
      ? selectedItems.value[0].name + '.zip'
      : `下载文件_${selectedItems.value.length}项.zip`;

    // 创建下载链接
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = fileName;
    link.style.display = 'none';
    document.body.appendChild(link);
    link.click();

    // 清理
    setTimeout(() => {
      document.body.removeChild(link);
      window.URL.revokeObjectURL(url);
    }, 100);

    ElMessage.success('下载成功');
  } catch (error: any) {
    console.error('下载失败:', error);
    ElMessage.error('下载失败：' + (error.message || '未知错误'));
  } finally {
    loading.value = false;
  }
};

// 删除单个文件
const handleDeleteSingle = async (row: any) => {
  try {
    await ElMessageBox.confirm(`确定要删除"${row.name}"吗?`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    });

    loading.value = true;
    await userDeleteSingle(row.key);
    ElMessage.success('删除成功');
    refreshList();
  } catch (error: any) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败');
    }
  } finally {
    loading.value = false;
  }
};

// 批量删除
const handleDelete = async () => {
  if (selectedItems.value.length === 0) {
    ElMessage.warning('请选择要删除的文件或文件夹');
    return;
  }

  try {
    await ElMessageBox.confirm(
      `确定要删除选中的 ${selectedItems.value.length} 项吗?`,
      '提示',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    );

    loading.value = true;
    const paths = selectedItems.value.map(item => item.key);
    await userDeleteMultiple(paths);
    ElMessage.success('删除成功');
    refreshList();
  } catch (error: any) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败');
    }
  } finally {
    loading.value = false;
  }
};

// 初始化
onMounted(() => {
  loadFileList();
});
</script>

<style lang="scss" scoped>
.breadcrumb {
  margin-bottom: 20px;
  padding: 10px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.mb8 {
  margin-bottom: 8px;
}

:deep(.el-upload-dragger) {
  padding: 20px;
}

.upload-drop-zone {
  border: 2px dashed #dcdfe6;
  border-radius: 6px;
  padding: 40px 20px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
  background-color: #fafafa;

  &:hover {
    border-color: #409eff;
    background-color: #f0f9ff;
  }

  &.is-dragover {
    border-color: #409eff;
    background-color: #e6f7ff;
  }
}

.upload-icon {
  font-size: 67px;
  color: #c0c4cc;
  margin-bottom: 16px;
}

.upload-text {
  color: #606266;
  font-size: 14px;
  margin-bottom: 20px;
}

.upload-actions {
  display: flex;
  gap: 10px;
  justify-content: center;
}

.selected-files {
  margin-top: 20px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  overflow: hidden;
}

.selected-files-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  background-color: #f5f7fa;
  border-bottom: 1px solid #ebeef5;
  font-size: 14px;
  color: #606266;
}

.selected-files-list {
  max-height: 200px;
  overflow-y: auto;
}

.file-item {
  display: flex;
  align-items: center;
  padding: 8px 15px;
  border-bottom: 1px solid #f5f7fa;
  font-size: 13px;

  &:last-child {
    border-bottom: none;
  }

  .el-icon {
    margin-right: 8px;
    color: #909399;
  }

  .file-name {
    flex: 1;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    color: #606266;
  }

  .file-size {
    margin-left: 10px;
    color: #909399;
    font-size: 12px;
  }
}

.file-item-more {
  padding: 8px 15px;
  text-align: center;
  color: #909399;
  font-size: 12px;
}
</style>
