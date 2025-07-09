# Organisation Info Parser

Search for Organisations, ASNs and Networks in a local Whois database.

Expand your attack surface. Useful for doing recon on big companies.

Sources (organisation, inetnum, aut-num):
- RIPE
- APNIC
- AfriNIC

ARIN only provides a public "route" database - so it's not useful for us.

LACNIC only provides a public "inetnum" database, but it doesn't include anything except for CIDRs - useless.

## Docker

```sh
git clone https://github.com/sttlr/org_info
cd org_info
```

Then run:
```sh
./bin/setup
```

Or if you want to preserve database files:
```sh
./download_dumps.sh
./bin/setup-dev
```

By default, everything is downloaded:
 - All regions: `AfriNIC`, `APNIC`, `RIPE`
 - IPv4 and IPv6 networks

To download specific regions only, specify them as arguments:
```sh
./download_dumps.sh ripe apnic afrinic
```

NOTE: When using specific regions - IPv6 networks won't be downloaded. To download IPv6 networks - append `ipv6` to arguments.

The container and the database remain, so you can `docker stop` and `docker start` when you need to.

## Usage

By default, `org_name` uses `full` output mode (displays all available columns) - useful for grepping and filtering:
```sh
./bin/query_inetnum 'hilton'
194.30.241.128/28  | HILTONATH-LL                                                   | athens hilton hotel
212.134.146.160/27 | CYBERIA-GRANADA                                                | Cyberia Cybercafe, Hilton Park Services Area, M6 Staffordshire,
195.184.237.160/28 | MISTRAL-ADSL-HSC                                               | ADSL: Hilton Sharp & Clark
62.189.29.32/28    | PAHILTON01                                                     | PA Hilton Limited
192.114.166.136/29 | HILTON                                                         | Hilton Tel Aviv
212.47.23.192/28   | HILTON3-CZ                                                     | Hilton Prague
...
```

If you're not interested in other columns, you can switch to `short` output mode by setting the value of the `ORG_INFO_OUTPUT_MODE` environment variable to `short`:
```sh
ORG_INFO_OUTPUT_MODE=short ./bin/query_inetnum 'hilton'
194.30.241.128/28
212.134.146.160/27
62.189.29.32/28
192.114.166.136/29
212.47.23.192/28
...
```

### ASN search
Searches for `orgname` in `as-name` or `description`:
```
./bin/query_asn orgname
```

### Organisation search
Searches for `orgname` in organisation name or handle:
```
./bin/query_org orgname
```

### Network (CIDR) search
Searches for `orgname` in `netname` or `description`:
```
./bin/query_intenum orgname
```

### Spawn interactive PSQL prompt
```
./bin/psql
```

## Examples
Get CIDRs that belong to Hilton:
```sh
$ ORG_INFO_OUTPUT_MODE=short ./bin/query_inetnum hilton
202.123.21.64/29
196.1.237.136/29
212.0.147.16/29
41.208.5.252/32
212.0.143.88/29
...(SKIPPED)
2a0e:b107:19cf::/48
2001:920:1847:6b00::/56
```

Get ASNs that belong to Hilton:
```sh
$ ORG_INFO_OUTPUT_MODE=short ./bin/query_asn hilton    
AS135157
AS35748
AS57483
```

Get Organisation handles that belong to Hilton:
```sh
$ ORG_INFO_OUTPUT_MODE=short ./bin/query_org hilton
ORG-HHL4-AP
ORG-HCA14-RIPE
ORG-IANC2-RIPE
ORG-CJ203-RIPE
```

## Note
Because query scripts use wildcards (`ILIKE '%orgname%'`), you should double-check the results.

For example, organisation `ORG-IANC2-RIPE` has a name of `Ian Chilton`, but it **doesn't** belong to Hilton. It just so happens that there is "hilton" in the name.
