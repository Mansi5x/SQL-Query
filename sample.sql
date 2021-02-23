Select a.Check_No,a.gross,b.CGST,b.SGST,b.Discount,(a.gross+b.CGST+b.SGST+b.Discount) as Net
from
(
	select a.Client_Id,a.Property_Id,a.Check_No,sum(b.Item_Qty * b.Item_Rate) as gross
	from 
	crsPOSTable a
	inner join
	crsPOSItem b
	on
	a.Client_Id = b.Client_Id and
	a.Property_Id = b.Property_Id and
	a.Check_No = b.Check_No
	where
	a.Client_Id = '6038' and
	a.Property_Id = '00000007' and
	a.Check_Date = '19-may-2020' 	
	Group by a.Client_Id,a.Property_Id,a.Check_No
) as a,
(
	select a.Client_Id,a.Property_Id,a.Check_No,
	sum(Case when b.Charge_Id = 'POSDISC' then 
		Case when b.Trans_Type = 'D' then b.Amount else b.Amount * -1 end  
	else 0 end) as Discount,
	sum(Case when c.IsCGST = 'Y' then
		Case when b.Trans_Type = 'D' then b.Amount else b.Amount * -1 end  
	else 0 end) as CGST ,
	sum(Case when c.IsSGST = 'Y' then
		Case when b.Trans_Type = 'D' then b.Amount else b.Amount * -1 end  
	else 0 end) as SGST 
	from 
	crsPOSTable a
	inner join 
	crsPOSCharge b
	on
	a.Client_Id = b.Client_Id and
	a.Property_Id = b.Property_Id and
	a.Check_No = b.Check_No 
	inner join
	crsChargeMaster c
	on
	b.Client_Id = c.Client_ID and
	b.Property_Id = c.Property_ID and
	b.Charge_Id = c.Charge_ID
	where
	a.Client_Id = '6038' and
	a.Property_Id = '00000007' and
	a.Check_Date = '19-may-2020' 
	Group by a.Client_Id,a.Property_Id,a.Check_No
) as b
where
a.Client_Id = b.Client_Id and
a.Property_Id = b.Property_Id and
a.Check_No = b.Check_No		