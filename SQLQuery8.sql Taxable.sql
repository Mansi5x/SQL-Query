select s.Client_Id,s.Property_Id,s.Check_No,s.gross,ISNULL(x.Taxable,0) as Taxable,s.Discount,s.CGST,s.SGST,s.Net 
from 
( 

	Select a.Client_Id,a.Property_Id,a.Check_No,sum(a.Gross) as Taxable
	from 
	(
		select a.Client_Id,a.Property_Id,a.Check_No,b.Charge_Id,
		sum(Item_Qty * Item_Rate) as Gross
		from 
		crsPOSTable  a with (nolock),
		crsPOSItem b with (nolock)
		where
		a.Client_Id = '6038' and
		a.Property_Id = '00000007' and
		a.Check_Date = '1-apr-2020' and
		a.Client_Id = b.Client_Id and
		a.Property_Id = b.Property_Id and
		a.Check_No = b.Check_No 
		Group by a.Client_Id,a.Property_Id,a.Check_No,b.Charge_Id
	) a ,     
	 (
		select a.Client_Id,a.Property_Id,a.Check_No,b.AssoCharge_ID
		from 
		crsPOSTable  a with (nolock),
		crsPOSCharge b with (nolock)
		where
		a.Client_Id = '6038' and
		a.Property_Id = '00000007' and
		a.Check_Date = '1-apr-2020' and
		a.Client_Id = b.Client_Id and
		a.Property_Id = b.Property_Id and
		a.Check_No = b.Check_No and
		b.Charge_Id <> 'POSRND' and 
		b.Charge_Id <> 'POSDISC'
		Group by a.Client_Id,a.Property_Id,a.Check_No,b.AssoCharge_ID
	) as b
	where
	a.Client_Id = b.Client_Id and
	a.Property_Id = b.Property_Id and
	a.Check_No = b.Check_No and
	a.Charge_Id = b.AssoCharge_ID 
	Group by a.Client_Id,a.Property_Id,a.Check_No
) as  x
right outer join
(
	select a.Client_Id,a.Property_Id,a.Check_No,a.gross,isnull(b.CGST,0) as CGST,isnull(b.SGST,0) as SGST,isnull(b.Discount,0) Discount,
	(a.gross + isnull(b.CGST,0) +isnull(b.SGST,0) + isnull(b.Discount,0)) as Net 
	from  
	( 
			select  a.Client_Id,a.Property_Id,a.Check_No,sum(b.Item_Qty * b.Item_Rate) as gross 
			from 
			crsPOSTable a with (nolock),
			crsPOSItem b  with (nolock)
			where
			a.Client_Id =  '6038' and
			a.Property_Id = '00000007' and
			a.Check_Date = '1-apr-2020' and
			a.Client_Id =b.Client_Id and
			a.Property_Id = b.Property_Id and
			a.Check_No = b.Check_No 
			group by a.Client_Id,a.Property_Id,a.Check_No
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
			a.Client_Id = b.Client_Id and
			a.Property_Id = b.Property_Id and
			a.Check_No = b.Check_No ,
			crsChargeMaster c with (nolock)
			where
			a.Client_Id ='6038' and
			a.Property_Id = '00000007' and
			a.Check_Date = '1-Apr-2020' and
			b.Client_Id = c.Client_Id and
			b.Property_Id = c.Property_Id and
			b.Charge_Id = c.Charge_Id  
			group by a.Client_Id,a.Property_Id,a.Check_No
	 ) as b 
	  on
	  a.Client_Id = b.Client_Id and
	  a.Property_Id = b.Property_Id and
	  a.Check_No = b.Check_No
) as s
on
x.Client_Id = s.Client_Id and
x.Property_Id = s.Property_Id and	 
x.Check_No = s.Check_No
 --and s.Discount = 0


