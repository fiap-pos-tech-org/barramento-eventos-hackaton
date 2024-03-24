# barramento-eventos
Event-driven AWS resource terraform files

#### Lista de recursos:
##### Filas
- registry_queue
- report_queue


##### Tópicos
- registry_topic
- report_notification_topic


#### Vínculos:
> registry_topic -> registry_queue ("timeClockId": [{"exists": true}])

> registry_topic -> report_queue ("yearMonth": [{"exists": true}])

> report_notification_topic -> Email