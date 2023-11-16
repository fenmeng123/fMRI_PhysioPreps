% Fill 

matlabbatch{1}.spm.tools.physio.save_dir = {'E:\研究生\科研工作\231104磁共振生理数据处理\fMRI_PhysioPreps\demo\PhysIO_Outputs'};
matlabbatch{1}.spm.tools.physio.log_files.cardiac = {'E:\研究生\科研工作\231104磁共振生理数据处理\fMRI_PhysioPreps\demo\20231114_lixin.ecg'};
matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {'E:\研究生\科研工作\231104磁共振生理数据处理\fMRI_PhysioPreps\demo\20231114_Y02_ZH.MR.PROJECT_BNU-ZJT.2.1.2023.11.14.11.13.39.866.30729809.dcm'};
matlabbatch{1}.spm.tools.physio.model.output_multiple_regressors = 'multiple_regressors.txt';
matlabbatch{1}.spm.tools.physio.model.output_physio = 'physio.mat';

% List of open inputs
jobfile = {'E:\研究生\科研工作\231104磁共振生理数据处理\fMRI_PhysioPreps\demo\PhysIO_Batch_job.m'};
spm('defaults', 'FMRI');
spm_jobman('run', jobfile);
