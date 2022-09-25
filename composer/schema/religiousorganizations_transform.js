function transform(line) {
	var values=line.split(',');
	var obj = new Object();
	obj.Category = values[0];
	obj.Name = values[1];
	obj.Address = values[2];
	obj.Suburb = values[3];	
	obj.State = values[4];
	obj.Postcode = values[5];
	obj.CombinedAddress = values[6];
	obj.Latitude = values[7];	
	obj.Longitude = values[8];
	obj.Fax = values[9];
	obj.Email = values[10];
	obj.Website = values[11];	
	obj.Staff = values[12];
	obj.Established = values[13];
	obj.ABN = values[14];
	obj.ABN_Status = values[15];	
	obj.ABN_Type = values[16];
	obj.ABN_Accuracy = values[17];	
	var jsonString= JSON.stringify(obj);
	return jsonString;
}	



















