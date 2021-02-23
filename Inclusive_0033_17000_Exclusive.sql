--select a.Client_Id,a.Property_Id,a.Check_Date
--from 
--crsPOSTable  a with (nolock) ,
--crsPOSItem b  with (nolock)
--where
--a.Client_Id = '6038' and
--a.Property_Id = '00000007' and
--a.Check_Date = '19-May-2018' and
--a.Client_Id = b.Client_Id and
--a.Property_Id = b.Property_Id and
--a.Check_Date = b.Check_Date
--group by a.Client_Id,a.Property_Id,a.Check_Date


select a.Client_Id,a.Property_Id,a.Check_No,a.Check_Date,
Case when a.Tax_Inclusive = 'Y' then  a.gross - isnull(b.CGST,0) - isnull(b.SGST,0) else a.gross end as Gross,
isnull(b.CGST,0) as CGST,isnull(b.SGST,0) as SGST,isnull(b.Discount,0) Discount,
(Case when a.Tax_Inclusive = 'Y' then  a.gross - isnull(b.CGST,0) - isnull(b.SGST,0) else a.gross end + isnull(b.CGST,0) + isnull(b.SGST,0) + isnull(b.Discount,0)) as Net 
from  
( 
	select  a.Client_Id,a.Property_Id,a.Check_No,a.Check_Date,a.Tax_Inclusive,sum(b.Item_Qty * b.Item_Rate) as gross 
	from 
	crsPOSTable a with (nolock),
	crsPOSItem b  with (nolock)
	where
	a.Client_Id =  '6038' and
	a.Property_Id = '00000007' and
	a.Check_Date = '19-May-2018' and
   	a.Client_Id = b.Client_Id and
	a.Property_Id = b.Property_Id and
	a.Check_No = b.Check_No and
	a.Check_Date = b.Check_Date
	Group by a.Client_Id,a.Property_Id,a.Check_No,a.Check_Date,a.Tax_Inclusive
)as a
left outer join 
(
	select a.Client_Id,a.Property_Id,a.Check_No,
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
	a.Client_Id =  '6038' and
	a.Property_Id = '00000007' and
	a.Check_Date = '19-May-2018' and
	b.Tax_Inclusive <> '' and
	a.Client_Id = b.Client_Id and
	a.Property_Id = b.Property_Id and
	a.Check_No = b.Check_No and
	a.Tax_Inclusive = b.Tax_Inclusive,
	 crsPOSItem as x  with (nolock),
	crsChargeMaster c with (nolock)
	where
	a.Client_Id ='6038' and
	a.Property_Id = '00000007' and
	a.Check_Date = '19-May-2018' and
    b.Client_Id = c.Client_Id and
	b.Property_Id = c.Property_Id and
	b.Charge_Id = c.Charge_Id  and
	 b.Client_Id = x.Client_Id and
	b.Property_Id = x.Property_Id and
	b.Check_No = x.Check_No 
	group by a.Client_Id,a.Property_Id,a.Check_No,b.Tax_Inclusive	
) as b
on
a.Client_Id = b.Client_Id and
a.Property_Id = b.Property_Id and
a.Check_No = b.Check_No 


