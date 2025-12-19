<!-- src/components/FilePreview/index.vue -->
<template>
  <el-dialog
    v-model="visible"
    :title="fileName"
    width="80%"
    :close-on-click-modal="false"
    destroy-on-close
    @close="handleClose"
  >
    <div class="preview-container" v-loading="loading">
      <!-- 图片预览 -->
      <div v-if="fileType === 'image'" class="preview-image">
        <el-image
          :src="previewUrl"
          fit="contain"
          :preview-src-list="[previewUrl]"
          :initial-index="0"
        />
      </div>

      <!-- 视频预览 -->
      <div v-else-if="fileType === 'video'" class="preview-video">
        <video
          ref="videoRef"
          :src="previewUrl"
          controls
          autoplay
          class="video-player"
        />
      </div>

      <!-- 音频预览 -->
      <div v-else-if="fileType === 'audio'" class="preview-audio">
        <div class="audio-icon">
          <el-icon :size="80"><Headset /></el-icon>
        </div>
        <audio
          ref="audioRef"
          :src="previewUrl"
          controls
          autoplay
          class="audio-player"
        />
      </div>

      <!-- 文本预览 -->
      <div v-else-if="fileType === 'text'" class="preview-text">
        <pre>{{ textContent }}</pre>
      </div>

      <!-- Excel/Word 预览 -->
      <div v-else-if="fileType === 'excel' || fileType === 'word'" class="preview-office" v-html="htmlContent"></div>

      <!-- PDF 预览 -->
      <div v-else-if="fileType === 'pdf'" class="preview-pdf">
        <img v-for="(page, index) in pdfPages" :key="index" :src="page" />
      </div>

      <!-- 不支持的类型 -->
      <div v-else class="preview-unsupported">
        <el-icon :size="60"><Document /></el-icon>
        <p>暂不支持预览此类型文件</p>
      </div>
    </div>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { Headset, Document } from '@element-plus/icons-vue';
import { userDownloadSingle } from '@/api/filesys/user';
import { ElMessage } from 'element-plus';
import * as XLSX from 'xlsx';
import mammoth from 'mammoth';
import * as pdfjsLib from 'pdfjs-dist';
import pdfjsWorker from 'pdfjs-dist/build/pdf.worker.min.mjs?url';

pdfjsLib.GlobalWorkerOptions.workerSrc = pdfjsWorker;

interface Props {
  modelValue: boolean;
  fileKey: string;
  fileName: string;
}

const props = defineProps<Props>();
const emit = defineEmits(['update:modelValue']);

const loading = ref(false);
const previewUrl = ref('');
const textContent = ref('');
const htmlContent = ref('');
const pdfPages = ref<string[]>([]);
const videoRef = ref<HTMLVideoElement>();
const audioRef = ref<HTMLAudioElement>();

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
});

const imageExts = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg', 'ico'];
const videoExts = ['mp4', 'webm', 'ogg', 'mov', 'avi', 'mkv'];
const audioExts = ['mp3', 'wav', 'ogg', 'flac', 'aac', 'm4a'];
const textExts = ['txt', 'json', 'md', 'xml', 'yaml', 'yml', 'log', 'ini', 'conf', 'cfg'];
const excelExts = ['xlsx', 'xls'];
const wordExts = ['docx'];
const pdfExts = ['pdf'];

const fileType = computed(() => {
  const ext = props.fileName.split('.').pop()?.toLowerCase() || '';
  if (imageExts.includes(ext)) return 'image';
  if (videoExts.includes(ext)) return 'video';
  if (audioExts.includes(ext)) return 'audio';
  if (textExts.includes(ext)) return 'text';
  if (excelExts.includes(ext)) return 'excel';
  if (wordExts.includes(ext)) return 'word';
  if (pdfExts.includes(ext)) return 'pdf';
  return 'unknown';
});

const renderPdf = async (blob: Blob) => {
  const arrayBuffer = await blob.arrayBuffer();
  const pdf = await pdfjsLib.getDocument({ data: arrayBuffer }).promise;
  const pages: string[] = [];

  for (let i = 1; i <= pdf.numPages; i++) {
    const page = await pdf.getPage(i);
    const viewport = page.getViewport({ scale: 1.5 });
    const canvas = document.createElement('canvas');
    canvas.width = viewport.width;
    canvas.height = viewport.height;
    await page.render({ canvasContext: canvas.getContext('2d')!, viewport }).promise;
    pages.push(canvas.toDataURL());
  }
  pdfPages.value = pages;
};

const renderExcel = async (blob: Blob) => {
  const arrayBuffer = await blob.arrayBuffer();
  const workbook = XLSX.read(arrayBuffer, { type: 'array' });
  const sheet = workbook.Sheets[workbook.SheetNames[0]];

  const range = XLSX.utils.decode_range(sheet['!ref'] || 'A1');
  const merges = sheet['!merges'] || [];

  // 构建合并单元格映射
  const mergeMap = new Map<string, { rowspan: number; colspan: number }>();
  const skipCells = new Set<string>();

  merges.forEach(merge => {
    const startCell = XLSX.utils.encode_cell({ r: merge.s.r, c: merge.s.c });
    mergeMap.set(startCell, {
      rowspan: merge.e.r - merge.s.r + 1,
      colspan: merge.e.c - merge.s.c + 1
    });
    // 标记被合并的单元格
    for (let r = merge.s.r; r <= merge.e.r; r++) {
      for (let c = merge.s.c; c <= merge.e.c; c++) {
        if (r !== merge.s.r || c !== merge.s.c) {
          skipCells.add(XLSX.utils.encode_cell({ r, c }));
        }
      }
    }
  });

  let html = '<table class="excel-table"><tbody>';
  for (let r = range.s.r; r <= range.e.r; r++) {
    html += '<tr>';
    for (let c = range.s.c; c <= range.e.c; c++) {
      const addr = XLSX.utils.encode_cell({ r, c });
      if (skipCells.has(addr)) continue;

      const cell = sheet[addr];
      const value = cell ? (cell.w || cell.v || '') : '';
      const merge = mergeMap.get(addr);

      if (merge) {
        html += `<td rowspan="${merge.rowspan}" colspan="${merge.colspan}">${value}</td>`;
      } else {
        html += `<td>${value}</td>`;
      }
    }
    html += '</tr>';
  }
  html += '</tbody></table>';

  htmlContent.value = html;
};


const loadPreview = async () => {
  if (!props.fileKey || !props.modelValue) return;

  loading.value = true;
  try {
    const blob = await userDownloadSingle(props.fileKey);
    if (previewUrl.value) URL.revokeObjectURL(previewUrl.value);

    if (fileType.value === 'text') {
      textContent.value = await blob.text();
    } else if (fileType.value === 'excel') {
      await renderExcel(blob);
    } else if (fileType.value === 'word') {
      const arrayBuffer = await blob.arrayBuffer();
      const result = await mammoth.convertToHtml({ arrayBuffer });
      htmlContent.value = result.value;
    } else if (fileType.value === 'pdf') {
      await renderPdf(blob);
    } else {
      previewUrl.value = URL.createObjectURL(blob);
    }
  } catch (error) {
    console.error('预览错误:', error);
    ElMessage.error('加载预览失败');
    visible.value = false;
  } finally {
    loading.value = false;
  }
};

const handleClose = () => {
  if (previewUrl.value) {
    URL.revokeObjectURL(previewUrl.value);
    previewUrl.value = '';
  }
  textContent.value = '';
  htmlContent.value = '';
  pdfPages.value = [];
  if (videoRef.value) videoRef.value.pause();
  if (audioRef.value) audioRef.value.pause();
};

watch(() => props.modelValue, (val) => {
  if (val) loadPreview();
});
</script>

<style lang="scss" scoped>
.preview-container {
  min-height: 300px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.preview-image {
  max-height: 70vh;
  :deep(.el-image) {
    max-height: 70vh;
    img {
      max-height: 70vh;
      object-fit: contain;
    }
  }
}

.preview-video {
  width: 100%;
  .video-player {
    width: 100%;
    max-height: 70vh;
  }
}

.preview-audio {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 30px;
  padding: 40px;
  width: 100%;

  .audio-icon {
    color: #409eff;
  }

  .audio-player {
    width: 100%;
  }
}

.preview-text {
  width: 100%;
  max-height: 70vh;
  overflow: auto;
  background-color: #f5f7fa;
  border-radius: 4px;
  padding: 15px;

  pre {
    margin: 0;
    white-space: pre-wrap;
    word-wrap: break-word;
    font-family: Consolas, Monaco, 'Courier New', monospace;
    font-size: 14px;
    line-height: 1.5;
  }
}

.preview-office {
  width: 100%;
  max-height: 70vh;
  overflow: auto;
  background-color: #fff;
  padding: 15px;

  :deep(table) {
    border-collapse: collapse;
    width: 100%;

    td, th {
      border: 1px solid #ddd;
      padding: 8px;
    }
  }
}

.excel-table {
  border-collapse: collapse;
  width: 100%;

  td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
  }

  tr:nth-child(even) {
    background-color: #f9f9f9;
  }
}


.preview-pdf {
  width: 100%;
  max-height: 70vh;
  overflow: auto;

  img {
    width: 100%;
    display: block;
    margin-bottom: 10px;
  }
}


.preview-unsupported {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
  color: #909399;
}
</style>
