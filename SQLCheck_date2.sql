
select a.Client_Id,a.Property_Id,a.Check_Date
from 
crsPOSTable  a with (nolock) ,
crsPOSItem b  with (nolock)
where
a.Client_Id = '6038' and
a.Property_Id = '00000007' and
a.Check_Date >= '1-apr-2020' and
a.Check_Date <= '4-apr-2020' and
a.Client_Id = b.Client_Id and
a.Property_Id = b.Property_Id and
a.Check_Date = b.Check_Date
group by a.Client_Id,a.Property_Id,a.Check_Date

select a.Client_Id,a.Property_Id,a.Check_Date,a.gross,
isnull(b.CGST,0) as CGST,isnull(b.SGST,0) as SGST,isnull(b.Discount,0) Discount,
(a.gross + isnull(b.CGST,0) +isnull(b.SGST,0) + isnull(b.Discount,0)) as Net 
from  
( 
	select  a.Client_Id,a.Property_Id,a.Check_Date,Sum(b.Item_Qty * b.Item_Rate) as gross 
	from 
	crsPOSTable a with (nolock),
	crsPOSItem b  with (nolock)
	where
	a.Client_Id =  '6038' and
	a.Property_Id = '00000007' and
	a.Check_Date >= '1-apr-2020' and
    a.Check_Date <= '4-apr-2020' and
	a.Client_Id =b.Client_Id and
	a.Property_Id = b.Property_Id and
	a.Check_Date = b.Check_Date
	Group by a.Client_Id,a.Property_Id,a.Check_Date
)as a
left outer join 
(
	select a.Client_Id,a.Property_Id,a.Check_Date,
	sum(Case when b.Charge_Id = 'POSDISC' then 
		Case when b.Trans_Type = 'D' then b.Amount else b.Amount *-1 End else 0 end  ) as Discount,
	sum(Case when c.IsCGST = 'Y' then
		Case when b.Trans_Type = 'D' then b.Amount  else b.Amount -1 End else 0 End) as CGST,
	sum(Case when c.IsSGST = 'Y' then
		Case when b.Trans_Type = 'D' then b.Amount else b.Amount -1 End else 0 End) as SGST
		from 
	crsPOSTable a with (nolock)
	INNER JOIN
	crsPOSCharge b  with (nolock)
	on
	a.Client_Id = b.Client_Id and
	a.Property_Id = b.Property_Id and
	a.Check_No = b.Check_No,
	crsChargeMaster c with (nolock)
	where
	a.Client_Id ='6038' and
	a.Property_Id = '00000007' and
	a.Check_Date >= '1-apr-2020' and
    a.Check_Date <= '4-apr-2020' and
	b.Client_Id = c.Client_Id and
	b.Property_Id = c.Property_Id and
	b.Charge_Id = c.Charge_Id  
	group by a.Client_Id,a.Property_Id,a.Check_Date				
) as b 
on
a.Client_Id = b.Client_Id and
a.Property_Id = b.Property_Id and
a.Check_Date = b.Check_Date