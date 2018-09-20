For ($i=105; $i -le 110; $i++) {
    $VMname="192.168.4." + $i
    $VMMemory = Get-Random -InputObject 4, 8
    $VMCPU = Get-Random -InputObject 2, 4, 8
    $IP = $VMname
    $GW = "192.168.4.1"
    write-host "Name is  $VMname"
    new-vm -Name $VMname -VM 192.168.4.104 -VMhost lon06vsanstretchedcluster03.sdslab.net -Datastore vsanStretchedDatastore -OSCustomizationSpec TestVM_lon04
    Start-Sleep -Seconds 20
    Set-VM -VM $VMname -MemoryGB $VMMemory -NumCPU $VMCPU –Confirm:$False
    Start-Sleep -Seconds 10
    start-VM -VM $VMname
    Start-Sleep -Seconds 150
    Invoke-VMScript -VM $VMname "netsh interface ipv4 set addres ""Ethernet0"" static $IP 255.255.255.0 $GW" -GuestUser administrator -GuestPassword !QAZ2wsx
    }