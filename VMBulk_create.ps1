For ($i=105; $i -le 110; $i++) {
    $VMname="192.168.4." + $i
    $VMMemory = Get-Random -InputObject 4, 8
    $VMCPU = Get-Random -InputObject 2, 4, 8
    $IP = $VMname
    $GW = "192.168.4.1"
    $NM = "255.255.255.0"
    $ESXiHost = "testhost.lab.local"
    $Datastore = "vsanDatastore"
    $Customization = "TestVM_profile"
    $SourceVM = "SourceVMName"
    write-host "Name is  $VMname"
    new-vm -Name $VMname -VM $SourceVM -VMhost $ESXiHost -Datastore $Datastore -OSCustomizationSpec $Customization
    Start-Sleep -Seconds 20
    Set-VM -VM $VMname -MemoryGB $VMMemory -NumCPU $VMCPU –Confirm:$False
    Start-Sleep -Seconds 10
    start-VM -VM $VMname
    write-host “Waiting for VM Tools to Start”
    write-host “Waiting for VM Tools to Start”
    do {
    $toolsStatus = (Get-VM $VMname | Get-View).Guest.ToolsStatus
    write-host $toolsStatus
    sleep 3
    } until ( $toolsStatus -eq ‘toolsOk’ )
    Invoke-VMScript -VM $VMname "netsh interface ipv4 set address Ethernet0 static $IP $NM $GW" -GuestUser administrator -GuestPassword !QAZ2wsx
    Invoke-VMScript -VM $VMname "netsh interface ipv4 show config" -GuestUser administrator -GuestPassword !QAZ2wsx
}
