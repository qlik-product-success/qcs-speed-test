# Speed Test Tool

This repository is maintained by Qlik Customer First. It includes scripts and instructions on how to perform speed tests to a Qlik Cloud tenant.

# STEP-1 Generating Upload Test Files

1. Download [Create-Fake-Data-File.ps1](./Create-Fake-Data-File.ps1) to the server where the upload speed needs to be measured
1. Open PowerShell and change directories to the folder where the script in the previous step was downloaded/copied to.
1. Run the command below. 3 files should be created, a 5GB file, a 10GB file, and a 20GB file with a QVD extension.
    ```
    .\Create-Fake-Data-File.ps1 -Sizes 5120,10240,20480
    ```
    - Please note that these are not real QVD files meaning that they cannot be loaded in a Qlik Sense app. They are intended to prevent network compression and produce consistent upload results.
1. Open a browser, the latest version of Edge or Chrome is recommended.
1. Log in to your Qlik Cloud tenant and go to the Analytics .Home
1. Open Developer Tools to start collecting a HAR file.
1. Upload the 5GB, 10GB, and 20GB files at least 2 times each.
1. Export the HAR file.
1. If you are working with Qlik Product Support, then upload the HAR file to your support case folder OR follow Step-2 to process results

   
# STEP-2 Processing results of HAR
1. Download jq cmdlet using any windows package manager e.g. Chocolatey
2. Download "calc-qcs-upload-time.jq" to the server where the upload speed needs to be measured
3. Open PowerShell and change directories to the folder where the script in the previous step was downloaded/copied to.
4. Run the command below
    ```
     gc .\<har file> | jq -f C:\<directory>\calc-qcs-upload-time.jq
    ```


# License

This project is provided "AS IS", without any warranty, under the MIT License - see the [LICENSE](./LICENSE) file for details
