const imageExts = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg', 'ico'];
const videoExts = ['mp4', 'webm', 'ogg', 'mov', 'avi', 'mkv'];
const audioExts = ['mp3', 'wav', 'ogg', 'flac', 'aac', 'm4a'];
const textExts = ['txt', 'json', 'md', 'xml', 'yaml', 'yml', 'log', 'ini', 'conf', 'cfg'];
const excelExts = ['xlsx', 'xls'];
const wordExts = ['docx'];
const pdfExts = ['pdf'];

export const canPreview = (fileName: string): boolean => {
  const ext = fileName.split('.').pop()?.toLowerCase() || '';
  return [...imageExts, ...videoExts, ...audioExts, ...textExts, ...excelExts, ...wordExts, ...pdfExts].includes(ext);
};
