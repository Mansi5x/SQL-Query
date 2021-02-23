 select a.Client_Id,a.Property_Id,a.Check_No, sum(a.Gross) as Taxable 
 from
 (
 select a.Client_Id,a.Property_Id,a.Check_No,b.Charge_Id, sum (Item_Qty * Item_Rate) as Gross
 from 
 
 crsPOSTable a with (nolock),
 crsPOSItem b with (nolock)
 where
 a.Client_Id = b.Client_Id and
 a.Property_Id = b.Property_Id and
 a.Check_No = b.Check_No and
 a.Client_Id ='6038' and
 a.Property_Id = '00000007' and
 a.Check_Date = '1-4-2020' 
 Group by a.Client_Id,a.Property_Id,a.Check_No,b.Charge_Id
)a ,
(
  select a.Client_Id,a.Property_Id,a.Check_No,b.AssoCharge_ID
  from 
  crsPOSTable a  with (nolock),
  crsPOSCharge b  with (nolock)
  where
  a.Client_Id ='6038' and
  a.Property_Id = '00000007' and
  a.Check_Date = '1-4-2020' and
  a.Client_Id = b.Client_Id and
  a.Property_Id = b. Property_Id and
  a.Check_No = b.Check_No and
  b.Charge_Id  <>'POSDISC' and
  b.Charge_Id <> 'POSRND'
  Group by  a.Client_Id,a.Property_Id,a.Check_No,b.AssoCharge_ID
 ) as b
 where 
 a.Client_Id = b.Client_Id and
 a.Property_Id = b.Property_Id and
 a.Check_No = b.Check_No and
 a.Charge_Id = b.AssoCharge_ID
 Group by a.Client_Id,a.Property_Id,a.Check_No
 ) as a

