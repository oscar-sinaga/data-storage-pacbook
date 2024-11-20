import time
import luigi
import datetime
import traceback
import pandas as pd
from sqlalchemy import text

from .extract import Extract
from .utils.db_conn import dwh_db_connection
from .utils.log_config import log_config
from .utils.tables_src import tables
from .utils.root_dir import ROOT_DIR

class Load(luigi.Task):
    # Definisikan parameter
    current_timestamp = luigi.Parameter()

    def requires(self):
        return Extract()
    
    def run(self):
        logger = log_config("load", self.current_timestamp)
        logger.info("==================================PREPARATION - TRUNCATE DATA=======================================")

        # Truncating the tables before loading the data to avoid duplicates
        try:
            dwh_conn  = dwh_db_connection()
            with dwh_conn.connect() as conn:
                for table in tables:
                    select_query = text(f"SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '{table}'")
                    result = conn.execute(select_query)

                    if result.scalar_one_or_none():
                        truncate_query = text(f"TRUNCATE pacbook_src.{table} CASCADE")
                        
                        conn.execute(truncate_query)
                        conn.commit()

                        logger.info(f"TRUNCATE {table} - SUCCESS")
                    else:
                        logger.info(f"Table '{table}' does not exist, skipping truncate operation")
            logger.info("TRUNCATE ALL TABLES - DONE")

        except Exception as e:
            logger.error(f"TRUNCATE DATA - FAILED: {e}\n{traceback.format_exc()}")
        
        logger.info("==================================ENDING PREPARATION=======================================")
        logger.info("==================================STARTING LOAD DATA=======================================")

        # Loading the data after the tables already empty
        try:
            start_time = time.time()

            for table in tables:
                df = pd.read_csv(f"{ROOT_DIR}/data_source/data_extract/{table}.csv")
                df.to_sql(
                    name=table,
                    con=dwh_conn,
                    schema="pacbook_src",
                    if_exists="append",
                    index=False
                )
                logger.info(f"LOAD '{table}' - SUCCESS")

            dwh_conn.dispose()    
            logger.info("LOAD ALL DATA - SUCCESS")

            end_time = time.time()
            exe_time = end_time - start_time

            summary_data = {
                "timestamp": [datetime.datetime.now()],
                "task": ["Load"],
                "status": ["Success"],
                "execution_time": [exe_time]
            }
            summary = pd.DataFrame(summary_data)
            summary.to_csv(f"{ROOT_DIR}/summary_pipeline.csv", index=False, mode="a")
        except Exception as e:
            logger.error(f"LOAD ALL DATA - FAILED: {e}\n{traceback.format_exc()}")

            summary_data = {
                "timestamp": [datetime.datetime.now()],
                "task": ["Load"],
                "status": ["Failed"],
                "execution_time": [0]
            }
            summary = pd.DataFrame(summary_data)
            summary.to_csv(f"{ROOT_DIR}/summary_pipeline.csv", index=False, mode="a")
        
        logger.info("==================================ENDING LOAD DATA=======================================")
    
    def output(self) -> luigi.LocalTarget:
        return luigi.LocalTarget(f"{ROOT_DIR}/log/task_timestamp/load_{self.current_timestamp}.log")