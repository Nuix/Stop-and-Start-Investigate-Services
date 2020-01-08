# Stop and Start Investigate Services
Batch scripts which can be used to Stop, Start and Restart Investigate Windows Services

Depending on the version of Investigate being used you may need to edit the Service names being used. The naming will change
depending on the version initially installed as the update process does not change the service names. These scripts should work as
is for v8.2.0

This is performed by opening the script in a text editor and editing the service names to that shown in Windows Services
For example where your UMS service is "Nuix UMS" then make the following change

    SET service="Nuix-UMS"

would need to be changed to

    SET service="Nuix UMS"
