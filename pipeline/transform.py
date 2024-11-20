import time
import luigi
import datetime
import traceback
import pandas as pd
import subprocess as sp
import os
from .load import Load
from .utils.log_config import log_config
from .utils.root_dir import ROOT_DIR
import logging


class DbtTask(luigi.Task):
    command = luigi.Parameter()
    # Definisikan parameter
    current_timestamp = luigi.Parameter()

    def requires(self):
        pass
    
    def run(self):
        logger = log_config(f"transform", self.current_timestamp)
        logger.info(f"==================================STARTING TRANSFORM DATA - DBT {(self.command).upper()}=======================================")

        try:
            start_time = time.time()

            with open(f"{ROOT_DIR}/logs/transform/transform_{self.current_timestamp}.log", "a") as f:
                sp.run(
                    f"cd {ROOT_DIR}/pacbook_dwh/ && dbt {self.command}",
                    stdout=f,
                    stderr=sp.PIPE,
                    text=True,
                    shell=True,
                    check=True
                )

            logger.info(f"DBT {(self.command).upper()} - SUCCESS")

            end_time = time.time()
            exe_time = end_time - start_time

            summary_data = {
                "timestamp": [datetime.datetime.now()],
                "task": [f"Transform (DBT {self.command})"],
                "status": ["Success"],
                "execution_time": [exe_time]
            }
            summary = pd.DataFrame(summary_data)
            summary.to_csv(f"{ROOT_DIR}/summary_pipeline.csv", index=False, mode="a")
        # except Exception as e:
        except:
            logger.error(f"DBT {(self.command).upper()} - FAILED\n{traceback.format_exc()}")

            summary_data = {
                "timestamp": [datetime.datetime.now()],
                "task": [f"Transform (DBT {self.command})"],
                "status": ["Failed"],
                "execution_time": [0]
            }
            summary = pd.DataFrame(summary_data)
            summary.to_csv(f"{ROOT_DIR}/summary_pipeline.csv", index=False, mode="a")
        
        logger.info(f"==================================ENDING TRANSFORM DATA - DBT {(self.command).upper()}=======================================")
    
        # Handler untuk log file
        file_handler = logging.FileHandler(os.path.join(ROOT_DIR,'log','transform_dbt_timestamp', f"{self.command}_{self.current_timestamp}.log"))
        formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
    def output(self) -> luigi.LocalTarget:
        return luigi.LocalTarget(f"{ROOT_DIR}/log/transform_dbt_timestamp/{self.command}_{self.current_timestamp}.log")

class DbtDebug(DbtTask):
    command = "debug"

    def requires(self):
        return Load()

class DbtDeps(DbtTask):
    command = "deps"

    def requires(self):
        return DbtDebug()

class DbtRun(DbtTask):
    command = "run"

    def requires(self):
        return DbtDeps()

class DbtSnapshot(DbtTask):
    command = "snapshot"

    def requires(self):
        return DbtRun()

class DbtTest(DbtTask):
    command = "test"

    def requires(self):
        return DbtSnapshot()