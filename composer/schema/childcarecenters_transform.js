function transform(line) {
	var values=line.split(',');
	var obj = new Object();
	obj.Name = values[0];
	obj.Categories = values[1];
	obj.Address = values[2];
	obj.City = values[3];	
	obj.State = values[4];
	obj.Postcode = values[5];
	obj.Phone = values[6];
	obj.Fax = values[7];	
	obj.Latitude = values[8];
	obj.Longitude = values[9];
	obj.Employees = values[10];
	obj.Established = values[11];	
	obj.ABN_Status = values[12];
	obj.ABN = values[13];
	obj.ABN_Name = values[14];
	obj.Accuracy = values[15];	
	obj.ABN_2 = values[16];
	obj.ACN = values[17];	
	var jsonString= JSON.stringify(obj);
	return jsonString;
}	



















