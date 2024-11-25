import logging
from datetime import datetime
from .root_dir import ROOT_DIR
import os

# Fungsi untuk konfigurasi logger
def log_config(task: str, timestamp: str):
    logger = logging.getLogger(task)
    logger.setLevel(logging.INFO)

    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    
    # Handler untuk log file
    file_handler = logging.FileHandler(os.path.join(ROOT_DIR,'task_timestamp', f"{task}_{timestamp}.log"))
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    # Handler untuk log file
    file_handler = logging.FileHandler(os.path.join(ROOT_DIR,f"{task}", f"{task}.log"))
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    # Handler untuk log file
    file_handler = logging.FileHandler(os.path.join(ROOT_DIR,'timestamp', f"{timestamp}.log"))
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    # Handler untuk log file
    file_handler = logging.FileHandler(os.path.join(ROOT_DIR, f"log.log"))
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    # Handler untuk console (terminal)
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)

    return logger

# # Konfigurasi logger
# task_name = "extract"
# timestamp = datetime.now().strftime("%Y-%m-%dT%H-%M-%S")
# logger = log_config(task_name, timestamp)

# # Menulis log - akan muncul di file dan terminal
# logger.info("This log entry will appear in the terminal and be saved to the file.")
# logger.error("This is an error log example.")

# #########################################
# # Konfigurasi logger
# task_name = "load"
# timestamp = datetime.now().strftime("%Y-%m-%dT%H-%M-%S")
# logger = log_config(task_name, timestamp)

# # Menulis log - akan muncul di file dan terminal
# logger.info("This log entry will appear in the terminal and be saved to the file.")
# logger.error("This is an error log example.")

# #######################################
# # Konfigurasi logger
# task_name = "transform"
# timestamp = datetime.now().strftime("%Y-%m-%dT%H-%M-%S")
# logger = log_config(task_name, timestamp)

# # Menulis log - akan muncul di file dan terminal
# logger.info("This log entry will appear in the terminal and be saved to the file.")
# logger.error("This is an error log example.")
