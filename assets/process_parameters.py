import json

daily = json.load(open('parameters_daily.json', 'rb'))
monthly = json.load(open('parameters_monthly.json', 'rb'))
climatology = json.load(open('parameters_climatology.json', 'rb'))

params_keys = list(set(list(daily.keys()) + list(monthly.keys()) + list(climatology.keys())))
params = {}

for key in params_keys:
    temporal = []
    if key in daily.keys():
        temporal.append('DAILY')
        params[key] = daily[key].copy()
    if key in monthly.keys():
        temporal.append('MONTHLY')
        params[key] = monthly[key].copy()
    if key in climatology.keys():
        temporal.append('CLIMATOLOGY')
        params[key] = climatology[key].copy()
    params[key]['temporal'] = temporal

json.dump(params, open('parameters.json', 'w'), sort_keys=True, indent=2)
