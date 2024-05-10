SELECT
	hc.id AS house_contract_id,
	tc.id AS tenant_contract_id,
	t.id AS tenant_id,
	t."firstName" AS tenant_first_name,
	t."lastName" AS tenant_last_name,
	t.email AS tenant_email,
	t.phone AS tenant_phone_number,
	MAX(tr."meterReadingDate") AS most_recent_reading
	FROM public."HouseContract" hc
	INNER JOIN public."TenantContract" tc
	ON hc.id = tc."houseContractId"
	INNER JOIN public."Tenant" t
	ON t.id = tc."tenantId"
	INNER JOIN public."Service" s
	ON s."houseContractId" = hc.id
	INNER JOIN public."House" h
	ON hc."houseId" = h.id
	INNER JOIN public."MPxN" mpxn
	ON mpxn."houseId" = h.id
	INNER JOIN public."Meter" mt
	ON mpxn.id = mt."mpxnId"
	INNER JOIN public."TenantReading" tr
	ON tr."meterId" = mt.id
		WHERE s."utilityStatus" = 'ACTIVE'
		AND hc."isPortfolio" IS NOT TRUE
		AND hc."billingType" = 'BILL'
		AND mt."meterType" != 'SMART'
		AND tr."meterReadingDate" < CURRENT_DATE - 31
			GROUP BY hc.id, tc.id, t.id;