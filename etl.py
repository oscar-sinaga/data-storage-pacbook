import luigi
from pipeline.extract import Extract
from pipeline.load import Load
from pipeline.transform import DbtDebug, DbtDeps, DbtRun, DbtSnapshot, DbtTest
import datetime

if __name__ == "__main__":
    current_timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    luigi.build(
        [Extract(current_timestamp=current_timestamp), Load(current_timestamp=current_timestamp), 
         DbtDebug(current_timestamp=current_timestamp), DbtDeps(current_timestamp=current_timestamp), 
         DbtRun(current_timestamp=current_timestamp), DbtSnapshot(current_timestamp=current_timestamp), 
         DbtTest(current_timestamp=current_timestamp)],
        local_scheduler=True,
    )
