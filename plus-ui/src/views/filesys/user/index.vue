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
      <el-table-column type="selection" width="55" />
      <el-table-column label="名称" prop="name" min-width="200">
        <template #default="scope">
          <el-icon v-if="scope.row.type === 'folder'" style="margin-right: 5px">
            <Folder />
          </el-icon>
          <el-icon v-else style="margin-right: 5px">
            <Document />
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
      <el-table-column label="修改时间" prop="lastModified" width="180" />
      <el-table-column label="大小" prop="sizeStr" width="120" />
      <el-table-column label="操作" width="180">
        <template #default="scope">
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
        :auto-upload="false"
        :limit="1"
        :on-exceed="handleExceed"
        drag
      >
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
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
    <el-dialog v-model="uploadMultipleVisible" title="上传文件夹（ZIP格式）" width="500px">
      <el-upload
        ref="uploadMultipleRef"
        :auto-upload="false"
        :limit="1"
        :on-exceed="handleExceed"
        accept=".zip"
        drag
      >
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
        <div class="el-upload__text">
          拖拽ZIP文件到此处或 <em>点击上传</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">只能上传 ZIP 格式的压缩包</div>
        </template>
      </el-upload>
      <template #footer>
        <el-button @click="uploadMultipleVisible = false">取消</el-button>
        <el-button type="primary" @click="submitUploadMultiple">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts" name="UserFileIndex">
import { ref, onMounted, computed } from 'vue';
import { ElMessage, ElMessageBox, genFileId } from 'element-plus';
import type { UploadInstance, UploadProps, UploadRawFile } from 'element-plus';
import { Folder, Document, UploadFilled } from '@element-plus/icons-vue';
import {
  userList,
  userUploadSingle,
  userDownloadSingle,
  userDeleteSingle,
  userUploadMultiple,
  userDownloadMultiple,
  userDeleteMultiple
} from '@/api/filesys/user';
import type { FileList, Folder as FolderType, File as FileType } from '@/api/filesys/types';

// 数据定义
const loading = ref(false);
const currentPath = ref('');
const fileListData = ref<FileList | null>(null);
const selectedItems = ref<any[]>([]);
const uploadSingleVisible = ref(false);
const uploadMultipleVisible = ref(false);
const uploadSingleRef = ref<UploadInstance>();
const uploadMultipleRef = ref<UploadInstance>();

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
    const { data } = await userList(path);
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

// 上传单个文件
const handleUploadSingle = () => {
  uploadSingleVisible.value = true;
};

const submitUploadSingle = async () => {
  const uploadFiles = uploadSingleRef.value!.uploadFiles;
  if (uploadFiles.length === 0) {
    ElMessage.warning('请选择文件');
    return;
  }

  loading.value = true;
  try {
    await userUploadSingle(uploadFiles[0].raw!, currentPath.value);
    ElMessage.success('上传成功');
    uploadSingleVisible.value = false;
    uploadSingleRef.value!.clearFiles();
    refreshList();
  } catch (error) {
    ElMessage.error('上传失败');
  } finally {
    loading.value = false;
  }
};

// 上传文件夹
const handleUploadMultiple = () => {
  uploadMultipleVisible.value = true;
};

const submitUploadMultiple = async () => {
  const uploadFiles = uploadMultipleRef.value!.uploadFiles;
  if (uploadFiles.length === 0) {
    ElMessage.warning('请选择ZIP文件');
    return;
  }

  const file = uploadFiles[0].raw!;
  if (!file.name.endsWith('.zip')) {
    ElMessage.warning('只能上传ZIP格式文件');
    return;
  }

  loading.value = true;
  try {
    await userUploadMultiple(file, currentPath.value);
    ElMessage.success('上传成功');
    uploadMultipleVisible.value = false;
    uploadMultipleRef.value!.clearFiles();
    refreshList();
  } catch (error) {
    ElMessage.error('上传失败');
  } finally {
    loading.value = false;
  }
};

// 处理文件超出限制
const handleExceed: UploadProps['onExceed'] = (files) => {
  const upload = uploadSingleRef.value || uploadMultipleRef.value;
  upload!.clearFiles();
  const file = files[0] as UploadRawFile;
  file.uid = genFileId();
  upload!.handleStart(file);
};

// 下载单个文件
const handleDownloadSingle = async (row: any) => {
  loading.value = true;
  try {
    const response = await userDownloadSingle(row.key);
    const blob = new Blob([response.data]);
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = row.name;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    window.URL.revokeObjectURL(url);
    ElMessage.success('下载成功');
  } catch (error) {
    ElMessage.error('下载失败');
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
    const response = await userDownloadMultiple(paths);
    const blob = new Blob([response.data]);
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = 'download.zip';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    window.URL.revokeObjectURL(url);
    ElMessage.success('下载成功');
  } catch (error) {
    ElMessage.error('下载失败');
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
</style>
