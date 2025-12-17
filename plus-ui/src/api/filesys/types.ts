/**
 * 文件查询列表
 */
export interface FileList {
  parentKey: string;
  currentKey: string;
  currentName: string;
  folders: Folder[];
  files: File[];
}

/**
 * 目录
 */
export interface Folder {
  key: string;
  name: string;
}

/**
 * 文件
 */
export interface File {
  key: string;
  name: string;
  lastModified: string;
  tag: string;
  size: number;
}
