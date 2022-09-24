```mermaid
graph TD;
    Cli#makeconfig-->config.prepare_for_migrate;
    Cli#delete-->config.prepare_for_migrate;
    Cli#delete_db-->config.prepare_for_migrate;
    Cli#delete_migrate-->config.prepare_for_migrate;
```
