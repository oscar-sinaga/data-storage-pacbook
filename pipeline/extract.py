import time
import luigi
import datetime
import traceback
import pandas as pd
from .utils.db_conn import src_db_connection
from .utils.log_config import log_config
from .utils.tables_src import tables
from .utils.root_dir import ROOT_DIR

class Extract(luigi.Task):
    
   # Definisikan parameter
    current_timestamp = luigi.Parameter()
    # self.current_timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    def requires(self):
        pass

    def run(self):
        logger = log_config("extract", self.current_timestamp)
        logger.info("==================================STARTING EXTRACT DATA=======================================")
        
        try:
            start_time = time.time()    

            src_conn = src_db_connection()
            
            for table in tables:
                df = pd.read_sql_query(f"SELECT * FROM {table}", src_conn)
                df.to_csv(f"{ROOT_DIR}/data_source/data_extract/{table}.csv", index=False)

                logger.info(f"EXTRACT '{table}' - SUCCESS")
            
            src_conn.dispose()

            logger.info("EXTRACT ALL TABLES - DONE")

            end_time = time.time()
            exe_time = end_time - start_time

            summary_data = {
                "timestamp": [datetime.datetime.now()],
                "task": ["Extract"],
                "status": ["Success"],
                "execution_time": [exe_time]
            }
            summary = pd.DataFrame(summary_data)
            summary.to_csv(f"{ROOT_DIR}/summary_pipeline.csv", index=False, mode="a")
        except Exception as e:
            logger.error(f"EXTRACT ALL TABLES - FAILED: {e}\n{traceback.format_exc()}")

            summary_data = {
                "timestamp": [datetime.datetime.now()],
                "task": ["Extract"],
                "status": ["Failed"],
                "execution_time": [0]
            }
            summary = pd.DataFrame(summary_data)
            summary.to_csv(f"{ROOT_DIR}/summary_pipeline.csv", index=False, mode="a")
        
        logger.info("==================================ENDING EXTRACT DATA=======================================")

    def output(self) -> luigi.LocalTarget:
        return luigi.LocalTarget(f"{ROOT_DIR}/log/task_timestamp/extract_{self.current_timestamp}.log")
    
if __name__ == "__main__":
    luigi.run()
