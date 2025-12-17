import request from '@/utils/request';
import { AxiosPromise } from 'axios';
import { FileList } from '@/api/filesys/types';

/**
 * 用户获取自己文件列表
 * @param path
 * @returns {*}
 */
export const userList = (path?: string): AxiosPromise<FileList> => {
  return request({
    url: '/filesys/user/list',
    method: 'get',
    params: { path: path || '' }
  });
};

/**
 * 用户上传单个文件
 * @param file
 * @param path
 * @returns {*}
 */
export const userUploadSingle = (file: File, path?: string) => {
  const formData = new FormData();
  formData.append('file', file);
  return request({
    url: '/filesys/user/upload/single',
    method: 'post',
    params: { path: path || '' },
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  });
};

/**
 * 用户下载单个文件
 * @param path
 * @returns {*}
 */
export const userDownloadSingle = (path: string) => {
  return request({
    url: '/filesys/user/download/single',
    method: 'get',
    params: { path },
    responseType: 'blob'
  });
};

/**
 * 用户删除单个文件
 * @param path
 * @returns {*}
 */
export const userDeleteSingle = (path: string) => {
  return request({
    url: '/filesys/user/delete/single',
    method: 'post',
    params: { path }
  });
};

/**
 * 用户上传多个文件压缩包
 * @param file
 * @param path
 * @returns {*}
 */
export const userUploadMultiple = (file: File, path?: string) => {
  const formData = new FormData();
  formData.append('file', file);
  return request({
    url: '/filesys/user/upload/multiple',
    method: 'post',
    params: { path: path || '' },
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  });
};

/**
 * 用户下载多个文件到压缩包
 * @param paths
 * @returns {*}
 */
export const userDownloadMultiple = (paths: string[]) => {
  return request({
    url: '/filesys/user/download/multiple',
    method: 'get',
    params: { paths },
    paramsSerializer: {
      indexes: null // 序列化数组参数
    },
    responseType: 'blob'
  });
};

/**
 * 用户删除多个文件
 * @param paths
 * @returns {*}
 */
export const userDeleteMultiple = (paths: string[]) => {
  return request({
    url: '/filesys/user/delete/multiple',
    method: 'post',
    params: { paths },
    paramsSerializer: {
      indexes: null
    }
  });
};
