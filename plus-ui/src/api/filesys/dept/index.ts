import request from '@/utils/request';
import { AxiosPromise } from 'axios';
import { FileList } from '@/api/filesys/types';

/**
 * 管理员获取当前部门文件列表
 * @param path
 * @returns {*}
 */
export const deptList = (path?: string): AxiosPromise<FileList> => {
  return request({
    url: '/filesys/dept/list',
    method: 'get',
    params: { path: path || '' }
  });
};
