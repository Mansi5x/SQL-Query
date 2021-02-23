select a.Client_Id,a.Property_Id,a.Check_No,
sum(Item_qty * Item_Rate) as Taxes
from 
crsPOSCharge a 
INNER JOIN 
crsPOSItem b 
on 
a.Client_Id= b.Client_Id and
a.Property_Id = b.Property_Id and
a.check_no = b.check_no and
a.assoCharge_Id = b.Charge_Id
where
b.Client_Id = '6038' and
b.Property_Id = '00000007' and
b.Check_Date = '1-apr-2020' 	
Group by a.Client_Id,a.Property_Id,a.Check_No

select a.Client_Id, a.Property_Id,a.Check_No,a.Charge_Id
from
crsPOSItem a  INNER JOIN 
crsPOSCharge b 
on a.Client_Id = b.Client_Id and 
a.Property_Id = b.Property_Id and 
a.Check_No = b.Check_No 
 where
a.Charge_Id Values(POSRND <> POSDISC)






  
--case when condition then truevalue else falsevalue end
    
