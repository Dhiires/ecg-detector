import pathlib
import os

########################## INIT FUNCTIONS ##########################

def RunMethods(experiment, subject):    
    for i in range(8):
        pre_folder_path = current_dir.parent / 'DB_RR_intervals'
        specific_folder_path = 'RR_' + experiment + '_' + subject
        rr_folder_path = pre_folder_path / specific_folder_path
        
        if not os.path.exists(rr_folder_path):
            os.makedirs(rr_folder_path)
            
    return rr_folder_path

########################## END FUNCTIONS ##########################

current_dir = pathlib.Path(__file__).resolve()
parent_dir = current_dir.parent

data_dir = parent_dir / 'dataset_716' / 'experiment_data'

current_list = os.listdir(data_dir)

for subject in current_list:
    display_string = 'Reading ' + subject
    print(display_string)
    
    sub_list = os.listdir(data_dir / subject)
    for experiment in sub_list:
        if experiment == 'hand_bike':
            display_string = 'Experiment ' + experiment
            print(display_string)

            rr_folder_path = RunMethods(experiment,subject)
        
            wrong_file = 'annotation_' + experiment + '_' + subject + '.txt'
            wrong_file_path = rr_folder_path / wrong_file

            right_file = 'annotation_' + 'handbike_' + subject + '.txt'
            right_file_path = rr_folder_path / right_file
            
            pre_folder_path = current_dir.parent / 'DB_RR_intervals'
            right_folder_name = 'RR_' + 'handbike_' + subject
            right_folder_path = pre_folder_path / right_folder_name
            
            if os.path.exists(wrong_file_path):
                os.rename(wrong_file_path, right_file_path)
                
            if os.path.exists(rr_folder_path):
                os.rename(rr_folder_path,right_folder_path)
    
print("Finished")