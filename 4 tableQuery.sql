   
select * 
from 
crsChargeMaster
where
Client_ID = '6038'





select * 
from 
crsPOSTable
where
Client_ID = '6038' and
Property_Id = '00000007' and
Check_Date = '19-May-2018'





select * 
from 
crsPOSItem
where
Client_ID = '6038' and
Property_Id = '00000007' and
Check_Date = '19-May-2018'





select a.Client_Id,a.Property_Id,a.Check_No,a.SubSer_No,a.Invoice_No,a.Charge_Id,a.Trans_Type,a.Tax_Before_Disc,a.Tax_Inclusive,a.Amount,a.Discount,
a.AssoCharge_ID,a.IsExamption,a.OnAmt,a.OnAmtPer,a.Group_ID 
from 
crsPOSCharge a


inner join
crsPOSTable b
on
a.Client_Id = '6038' and
a.Property_Id = '00000007' and
a.Tax_Inclusive = 'Y' and
b.Check_Date='19-May-2018' and

a.Client_Id=b.Client_Id and
a.Property_Id=b.Property_Id and
a.Check_No=b.Check_No









