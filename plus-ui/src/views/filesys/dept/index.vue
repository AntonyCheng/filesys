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
        <el-button icon="Refresh" @click="refreshList">刷新</el-button>
      </el-col>
    </el-row>

    <!-- 文件列表 -->
    <el-table
      v-loading="loading"
      :data="tableData"
      @row-dblclick="handleRowDblClick"
    >
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
    </el-table>
  </div>
</template>

<script setup lang="ts" name="DeptFileIndex">
import { ref, onMounted, computed } from 'vue';
import { ElMessage } from 'element-plus';
import { Folder, Document, Back } from '@element-plus/icons-vue';
import { deptList } from '@/api/filesys/dept';
import type { FileList } from '@/api/filesys/types';

// 数据定义
const loading = ref(false);
const currentPath = ref('');
const fileListData = ref<FileList | null>(null);

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
    const { data } = await deptList(path);
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
</style>
