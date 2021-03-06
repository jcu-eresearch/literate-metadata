# Annotated MCP Metadata Record


## About this document

This annotated metadata record is an XML document, embedded in a Markdown
document written in a
[Literate](https://en.wikipedia.org/wiki/Literate_programming) style. The
Markdown describes the XML. Simple processing of the Markdown document
produces two output items; one, a HTML document for viewing in a web browser,
and an XML document which is the MCP metadata record.

A shell script is provided to do this processing. In the interests of
encapsulation, the final section of this document includes the source of the
shell script.

Major sources are:

* MCP 2.0 Manual
  * initially the
  [MCP Manual 2.0 Draft](http://bluenet3.antcrc.utas.edu.au/mcp-doc-20-draft/),
  which unfortunately had many broken links (and may now be inaccessible)
  * in April 2016, Craig Jones shared
  [this updated MCP 2.0 manual](http://mcp-profile-docs.readthedocs.org/)
  including alterations to `dataParameters` and elsewhere
* [ANZLIC profiles](http://asdd.ga.gov.au/asdd/profileinfo/)
* ANZLIC Metadata Profile Guidelines 1.0
* Example records from GeoNetwork
* Sample records from eAtlas


## Temporary fixes

This document attempts to comply with MCP 2.0. This is slightly difficult
because while writing this document, the MCP 2.0 schema isn't yet available
at any public URL. GeoNetwork happily uses its own internal definition of
the MCP2 schema without noticing that the schema URL returns a 404, but GN
still attempts to follow the various Codelist reference URLs. So, for now,
I'm using a path to the Codelist on github.

To switch this back, replace this github URL:

`https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml`

With this correct URL:

`http://schemas.aodn.org.au/mcp-2.0/schema/resources/Codelist/gmxCodelists.xml`


## Starting the XML document

The first item in the metadata record is a standard XML declaration.

    <?xml version="1.0" encoding="UTF-8"?>


## Root element

This identifies all the namespaces etc.

    <mcp:MD_Metadata
      xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
      xmlns:dwc="http://rs.tdwg.org/dwc/terms/"
      xmlns:gmd="http://www.isotc211.org/2005/gmd"
      xmlns:gco="http://www.isotc211.org/2005/gco"
      xmlns:gml="http://www.opengis.net/gml"
      xmlns:gmx="http://www.isotc211.org/2005/gmx"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      gco:isoType="gmd:MD_Metadata"
      xsi:schemaLocation="
        http://schemas.aodn.org.au/mcp-2.0 http://schemas.aodn.org.au/mcp-2.0/schema.xsd
        http://www.isotc211.org/2005/gmx http://www.isotc211.org/2005/gmx/gmx.xsd
      "
    >


### "File" identifier

This is a [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier)
that identifies the metadata record. The "file" part should be thought of as
relating to the abstract record, not any specific entity in a file system on
a hard drive somewhere.

The ID should be permanent across changes to the record or where it's stored.
This is used to create parent/child relationships.

    <gmd:fileIdentifier>
      <gco:CharacterString>dd87c239-3ef0-48f1-98c5-47e67af7f9d4</gco:CharacterString>
    </gmd:fileIdentifier>


### Language identifier

The language used in this metadata record (the record, not the language
used in the data itself). This can also be specified as an attribute of
the root element (`xmlns:language="eng"`), which would be less verbose.

    <gmd:language>
      <gco:CharacterString>eng</gco:CharacterString>
    </gmd:language>


### Character set

This declaration is perhaps an example of why XML formats didn't succeed as
much as they should have. This three hundred character tag describes the
encoding of the XML metadata document, and is unnecessary if your XML
declaration in the first line (`<?xml version="1.0" encoding="UTF-8"?>`)
specifies an encoding.

    <gmd:characterSet>
      <gmd:MD_CharacterSetCode
        codeListValue="utf8"
        codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"
      >utf8</gmd:MD_CharacterSetCode>
    </gmd:characterSet>


### Parent identifier

You *must* have a parent identifier if your dataset is part of a series (which
means there is another metadata record with `hierarchyLevel` set to `series`).
In that case, your `parentIdentifier` will be set to the same UUID at the
parent series' `fileIdentifier`.

The `hierarchyLevel` tag is only required if this is not a `dataset`.

So although this example shows a `dataset` with a blank parentIdentifier,
you can just delete both tags if this is a dataset with no parent.

    <gmd:parentIdentifier gco:nilReason="missing">
      <gco:CharacterString/>
    </gmd:parentIdentifier>

    <gmd:hierarchyLevel>
      <gmd:MD_ScopeCode
        codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_ScopeCode"
        codeListValue="dataset"
      >dataset</gmd:MD_ScopeCode>
    </gmd:hierarchyLevel>

The `gco:nilReason` attribute (which comes from XLink I think?) is used (and
[may be required to be `missing`](https://github.com/geonetwork/core-geonetwork/issues/309)
by geonetwork) when the `gco:CharacterString` tag is empty.


### Contacts connected to this metadata record

ISO19115 makes it mandatory to supply a contact responsible for the
**metadata record**. So it could be an eResearch staff member rather than
an academic. The actual data here is from the [ASDD example
record](http://asdd.ga.gov.au/asdd/profileinfo/ANZCW0703008022testSchematron.xml)
from the [ASDD site](http://asdd.ga.gov.au/asdd/profileinfo/).

    <gmd:contact>
      <gmd:CI_ResponsibleParty>

Note the claimed effect of the `gco:nilReason="withheld"` in the following
section. GeoNetwork does NOT respect this, so don't use `withheld`.

Also, note that the `individualName` field's value, copied from an ASDD
example, is formatted incorrectly according to the ISO19115 spec -- the
proper name format is `Surname GivenName Title` separated by a
"single delimiter". The standard gives a space as the example of a delimiter.
Later in the `citedResponsibleParty` section I've included the eAtlas example
that uses comma+space `, ` as the delimiter.

        <gmd:individualName gco:nilReason="withheld">
          <!-- The sub element gco:CharacterString and its content should be removed
            during presentation of this metadata because the gco:nilReason is set to "withheld". -->
          <gco:CharacterString>John Hockaday</gco:CharacterString>
        </gmd:individualName>
        <gmd:organisationName>
          <gco:CharacterString>Geoscience Australia (GA)</gco:CharacterString>
        </gmd:organisationName>
        <gmd:positionName>
          <gco:CharacterString>Director, Sales and Distribution, CIMA</gco:CharacterString>
        </gmd:positionName>

The contactInfo section is about how to contact the contact.

        <gmd:contactInfo>
          <gmd:CI_Contact>


#### Phone numbers

            <gmd:phone>
              <gmd:CI_Telephone>
                <gmd:voice>
                  <gco:CharacterString>+61 2 6249 9966</gco:CharacterString>
                </gmd:voice>
                <gmd:facsimile>
                  <gco:CharacterString>+61 2 6249 9960</gco:CharacterString>
                </gmd:facsimile>
              </gmd:CI_Telephone>
            </gmd:phone>

ISO 19115 says the `facsimile` number is optional, but an example record
from eAtlas included a fax number element with no content and a `nilReason`
of `missing`, like this:

`<gmd:facsimile gco:nilReason="missing"><gco:CharacterString /></gmd:facsimile>`

GeoNetwork is fine with missing tags inside the `CI_Telephone` tag, so just
delete the ones you don't need.


#### Addresses

Note that `deliveryPoint` is where you put the street address, PO Box, etc.

            <gmd:address>
              <gmd:CI_Address>
                <gmd:deliveryPoint><gco:CharacterString>GPO Box 378</gco:CharacterString></gmd:deliveryPoint>
                <gmd:city><gco:CharacterString>Canberra</gco:CharacterString></gmd:city>
                <gmd:administrativeArea><gco:CharacterString>ACT</gco:CharacterString></gmd:administrativeArea>
                <gmd:postalCode><gco:CharacterString>2601</gco:CharacterString></gmd:postalCode>
                <gmd:country><gco:CharacterString>Australia</gco:CharacterString></gmd:country>
                <gmd:electronicMailAddress><gco:CharacterString>sales@ga.gov.au</gco:CharacterString></gmd:electronicMailAddress>
              </gmd:CI_Address>
            </gmd:address>

It's *electronicMailAddress* and *facsimile* rather than "emailAddress" and "fax",
but at least it's *phone* rather than "telephone" (or "[electric telegraph
transmission and reception device](https://www.google.com.au/patents/US161739)").

Optionally the contact person can have an `onlineResource`; this example is
from an eAtlas record, and links to the root of the
[eAtlas](http://eatlas.org.au) site, presumably to help the reader find
contact details if the individual named here is no longer available.

The `protocol` tag is more-of-less freeform (you can say `http` if you want),
but you get some special client behaviour if you choose the right ones.

            <gmd:onlineResource>
              <gmd:CI_OnlineResource>
                <gmd:linkage>
                  <gmd:URL>http://eatlas.org.au</gmd:URL>
                </gmd:linkage>
                <gmd:protocol>
                  <gco:CharacterString>WWW:LINK-1.0-http--link</gco:CharacterString>
                </gmd:protocol>
                <gmd:name>
                  <gco:CharacterString>eAtlas portal</gco:CharacterString>
                </gmd:name>
                <gmd:description gco:nilReason="missing">
                  <gco:CharacterString />
                </gmd:description>
              </gmd:CI_OnlineResource>
            </gmd:onlineResource>

(Completing the contact-info part of the contact.)

          </gmd:CI_Contact>
        </gmd:contactInfo>

This contact is the metadata record handler, so should include the
`metadataContact` or `pointOfContact` role. The ASDD sample file didn't
include the string value, but eAtlas do, so I've included the eAtlas
example here. The ASDD version used a self-closing `gmd:CI_RoleCode` tag.

        <gmd:role>
          <gmd:CI_RoleCode
            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
            codeListValue="metadataContact"
          >
            metadataContact
          </gmd:CI_RoleCode>
        </gmd:role>


(Completing the required contact information.)

      </gmd:CI_ResponsibleParty>
    </gmd:contact>


### Creation date of metadata record

This `dateStamp` is the creation date of this record. It will never change.
The date format is [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) so you
can in theory use all sorts of crazy stuff like year-plus-ordinal-days
(`1999-365`), but the ANZLIC spec asks you to use one of a few formats, and
GeoNetwork's UI is picky about data format too. So stick with:

* bedtime on Xmas Eve, UTC: `2015-12-24T22:30:59`
* Xmas Eve: `2015-12-24`
* 21st Century: `20` *(just kidding, don't use this one)*

If you want to include a time portion, you need to use a `gco:DateTime`
tag rather than a `gco:Date`.

    <gmd:dateStamp>
      <gco:Date>2015-07-22</gco:Date>
    </gmd:dateStamp>


### Metadata standard used

This was optional in ANZLIC but is now required by MCP.

    <gmd:metadataStandardName>
      <gco:CharacterString>Australian Marine Community Profile of ISO 19115:2005/19139</gco:CharacterString>
    </gmd:metadataStandardName>
    <gmd:metadataStandardVersion>
      <gco:CharacterString>2.0</gco:CharacterString>
    </gmd:metadataStandardVersion>


### Identification info

This is a substantial portion of the XML, where the data is identified for
the purposes of discoverability, citation, etc.

    <gmd:identificationInfo>
      <mcp:MD_DataIdentification gco:isoType="gmd:MD_DataIdentification">

To save some indenting space, I'm resetting the indentation for
the content of this `MD_DataIdentification` tag -- the following XML is two
levels less indented than you would expect.

**Tag ordering matters here**. Unfortunately it's unclear what
the correct order is. The XML standard defines one set, and a list in a
software requirement specification forwarded by Roger Proctor asks for a
different ordering. Another fun detail is how the two lists don't include
the same tags.

List from [the schema](https://github.com/aodn/schema-plugins/blob/master/iso19139.mcp-2.0/schema/gmd/identification.xsd):

1. `citation`
1. `abstract`
1. `purpose`
1. `credit`
1. `status`
1. `pointOfContact`
1. `resourceMaintenance`
1. `graphicOverview`
1. `resourceFormat`
1. `descriptiveKeywords`
1. `resourceSpecificUsage`
1. `resourceConstraints`
1. `aggregationInfo`


List from the spec (which is a confidential PDF, ask Daniel for a look):

1. `citation`
1. `abstract`
1. `purpose`
1. `status`
1. `resourceMaintenance`
1. `resourceFormat`
1. `descriptiveKeywords`
1. `resourceConstraints`
1. `language`
1. `characterSet`
1. `topicCategory`
1. `extent`
1. `samplingFrequency`
1. `dataParameters`
1. `pointOfContact`
1. `supplementalInformation`
1. `credit`

For now I'm following the spec, which imports into GeoNetwork properly.


#### Citation

This section provides info about how to cite the data (the data itself, not
this metadata record).

    <gmd:citation>
      <gmd:CI_Citation>


##### Title and date

The title is the "official" name of the dataset that should be used in
citations. Making up a title is only okay if the resource being described
has no official name. Title is required.

If there are common acronyms or other alternate titles, include any number of
`alternateTitle` tags.

        <gmd:title>
            <gco:CharacterString>Say goodbye to the Great Barrier Reef: Coral bleaching in 2016 (sample record, please delete)</gco:CharacterString>
        </gmd:title>
        <gmd:alternateTitle>
          <gco:CharacterString>ByeGBR</gco:CharacterString>
        </gmd:alternateTitle>

The date used for citing the data, which is usually a publication date.
I believe that abbreviated dates are acceptable (based on the ASDD sample,
which shows a `Revision` type date without including time-of-day info), but
you should switch the `gco:DateTime` for a `gco:Date` tag.

        <gmd:date>
          <gmd:CI_Date>
            <gmd:date>
              <gco:DateTime>2007-03-05T11:50:00</gco:DateTime>
            </gmd:date>
            <gmd:dateType>
              <gmd:CI_DateTypeCode
                codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                codeListValue="publication"
              >publication</gmd:CI_DateTypeCode>
            </gmd:dateType>
          </gmd:CI_Date>
        </gmd:date>


##### Citable people

There should be a `<citedResponsibleParty>` tag for each person who should be
named when citing this dataset (roughly equivalent to the authors of an
article).

Each `citedResponsibleParty` contains one `CI_ResponsibleParty`. This follows
the `CI_ResponsibleParty` already described in the *Contacts connected to this
metadata record* section above.

        <gmd:citedResponsibleParty>
          <gmd:CI_ResponsibleParty>

Individual identification for the citable person. Note that the ISO19115 spec
requires `Surname`, then `GivenName`, then `Title` separated by "the same
single delimiter". This example from eAtlas originally used a two character
sequence, comma+space `, ` as the delimiter (i.e. the value of the
`individualName` tag was `<gco:CharacterString>Grech, Alana,
Dr.</gco:CharacterString>`). From the spec's description I can't tell if a
two-char delimiter is okay or not. I've used a single space in this example.

GeoNetwork seems to just present the full string, so a space delimiter can be
confusing (e.g. when the honourable Baron Sascha Coen, the Baron of
Nettlestone, is referenced, he will appear as `Coen Sascha Baron`, which
appears ambiguous). I recommend using a comma + space for readability.

You need only include one of `individualName`, `organisationName`, and
`positionName`.

            <gmd:individualName>
              <gco:CharacterString>Grech Alana Dr</gco:CharacterString>
            </gmd:individualName>

The ISO spec says it's okay to have an acronym after the org name, e.g. `Ian
Atkinson Innovation University (IAIU)`.

            <gmd:organisationName>
              <gco:CharacterString>Coral Reef Studies ARC Centre of
              Excellence, James Cook University</gco:CharacterString>
            </gmd:organisationName>

Position name can't include abbreviations.

            <gmd:positionName>
              <gco:CharacterString>Postdoctoral Fellow</gco:CharacterString>
            </gmd:positionName>

Contact info for the citable person. Note the occasional
`gco:nilReason="missing"`.

            <gmd:contactInfo>
              <gmd:CI_Contact>
                <gmd:phone>
                  <gmd:CI_Telephone>
                    <gmd:voice>
                      <gco:CharacterString>+61 (0)7 4781 5222</gco:CharacterString>
                    </gmd:voice>
                    <gmd:facsimile gco:nilReason="missing">
                      <gco:CharacterString />
                    </gmd:facsimile>
                  </gmd:CI_Telephone>
                </gmd:phone>
                <gmd:address>
                  <gmd:CI_Address>
                    <gmd:deliveryPoint gco:nilReason="missing">
                      <gco:CharacterString />
                    </gmd:deliveryPoint>
                    <gmd:city>
                      <gco:CharacterString>Townsville</gco:CharacterString>
                    </gmd:city>
                    <gmd:administrativeArea>
                      <gco:CharacterString>Queensland</gco:CharacterString>
                    </gmd:administrativeArea>
                    <gmd:postalCode gco:nilReason="missing">
                      <gco:CharacterString />
                    </gmd:postalCode>
                    <gmd:country>
                      <gco:CharacterString>Australia</gco:CharacterString>
                    </gmd:country>
                    <gmd:electronicMailAddress>
                      <gco:CharacterString>alana.grech@jcu.edu.au</gco:CharacterString>
                    </gmd:electronicMailAddress>
                  </gmd:CI_Address>
                </gmd:address>
              </gmd:CI_Contact>
            </gmd:contactInfo>

Role this citable person served.

            <gmd:role>
              <gmd:CI_RoleCode
                codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                codeListValue="principalInvestigator"
              >principalInvestigator</gmd:CI_RoleCode>
            </gmd:role>

          </gmd:CI_ResponsibleParty>
        </gmd:citedResponsibleParty>

Here's another example of a citable person, so this record will have two
"author"ish people.

        <gmd:citedResponsibleParty>
          <gmd:CI_ResponsibleParty>

            <gmd:individualName>
              <gco:CharacterString>Marsh, Helene, Prof.</gco:CharacterString>
            </gmd:individualName>
            <gmd:organisationName>
              <gco:CharacterString>School of Earth and Environment, James Cook University</gco:CharacterString>
            </gmd:organisationName>
            <gmd:positionName>
              <gco:CharacterString>Dean of Graduate Research Studies</gco:CharacterString>
            </gmd:positionName>
            <gmd:contactInfo>
              <gmd:CI_Contact>
                <gmd:phone>
                  <gmd:CI_Telephone>
                    <gmd:voice>
                      <gco:CharacterString>+61 7 4781 5575</gco:CharacterString>
                    </gmd:voice>
                    <gmd:facsimile gco:nilReason="missing">
                      <gco:CharacterString />
                    </gmd:facsimile>
                  </gmd:CI_Telephone>
                </gmd:phone>
                <gmd:address>
                  <gmd:CI_Address>
                    <gmd:deliveryPoint gco:nilReason="missing">
                      <gco:CharacterString />
                    </gmd:deliveryPoint>
                    <gmd:city>
                      <gco:CharacterString>Townsville</gco:CharacterString>
                    </gmd:city>
                    <gmd:administrativeArea>
                      <gco:CharacterString>Queensland</gco:CharacterString>
                    </gmd:administrativeArea>
                    <gmd:postalCode gco:nilReason="missing">
                      <gco:CharacterString />
                    </gmd:postalCode>
                    <gmd:country>
                      <gco:CharacterString>Australia</gco:CharacterString>
                    </gmd:country>
                    <gmd:electronicMailAddress>
                      <gco:CharacterString>Helene.Marsh@jcu.edu.au</gco:CharacterString>
                    </gmd:electronicMailAddress>
                  </gmd:CI_Address>
                </gmd:address>

This person's info includes an onlineResource, which is a link to their staff
page. It takes around 1,000 characters to include this 60-character URL. The
two orders of magnitude is because XML is 100 times better than just text.

Options for the `protocol` tag's value are discussed in the later section on
how to get the dataset; here, you probably want to stick with
`WWW:LINK-1.0-http--link`.

                <gmd:onlineResource>
                  <gmd:CI_OnlineResource>
                    <gmd:linkage>
                      <gmd:URL>http://www.jcu.edu.au/ees/staff/academic/JCUDEV_008380.html</gmd:URL>
                    </gmd:linkage>
                    <gmd:protocol>
                      <gco:CharacterString>WWW:LINK-1.0-http--link</gco:CharacterString>
                    </gmd:protocol>
                    <gmd:name>
                      <gco:CharacterString>Professor Helene Marsh - JCU Staff page</gco:CharacterString>
                    </gmd:name>
                    <gmd:description gco:nilReason="missing">
                      <gco:CharacterString />
                    </gmd:description>
                  </gmd:CI_OnlineResource>
                </gmd:onlineResource>

              </gmd:CI_Contact>
            </gmd:contactInfo>
            <gmd:role>
              <gmd:CI_RoleCode
                codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                codeListValue="coInvestigator"
              >coInvestigator</gmd:CI_RoleCode>
            </gmd:role>
          </gmd:CI_ResponsibleParty>
        </gmd:citedResponsibleParty>


(End of the citation info.)

      </gmd:CI_Citation>
    </gmd:citation>


#### Abstract, purpose, credit, and status

The abstract is mandatory, describes the content of the data being described,
and should be carefully composed to give a reader a good sense of fitness for
purpose. This is usually mined for keyword searches, so include any relevant
keywords.

    <gmd:abstract>
      <gco:CharacterString>
        This dataset shows a spatial model of somthing relative to another
        thing in a specified area, based on data collected over a period
        of some years. For more information on the methods used in the
        creation of this dataset see Grech. A., and Marsh. H. (2007) -
        Prioritising things for conservation in a marine protected area
        using a spatially explicit population model, Applied GIS, 3(2),
        1-14.
      </gco:CharacterString>
    </gmd:abstract>

The purpose is optional, and clarifies the intended use for the data
collection.

    <gmd:purpose>
      <gco:CharacterString>
        As zombies move over long distances and have a wide
        distributional range, it is important to identify areas
        of high long-term average zombie densities to prioritise
        elimination efforts.
      </gco:CharacterString>
    </gmd:purpose>

The credit is optional and allow recognition of people and organisations,
including funding bodies, who contributed to the dataset. MCP 2 guidelines
recommend including this tag but none of the examples I looked at had one.
Here's what I think it should look like.

    <gmd:credit>
      <gco:CharacterString>
        Charles Babbage, for starting it all.
        Pepsi Max, for caffeinating it.
      </gco:CharacterString>
    </gmd:credit>

The status is optional and captures the state of the dataset collection effort.
This tag is also recommended by the AODN's MCP2 guidelines. Generally you'll
use `completed` for most datasets, and `onGoing` for datasets that grow
forever.

    <gmd:status>
      <gmd:MD_ProgressCode
        codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_ProgressCode"
        codeListValue="onGoing"
      >onGoing</gmd:MD_ProgressCode>
    </gmd:status>


#### Point of contact

Who to talk to about the resource. Elsewhere you specify the entity
responsible for the metadata record, and the entity that manages access
to the dataset; this is the entity who actually knows about the dataset.
This is **mandatory** in MCP (it was optional in pre-MCP standards).

You've seen the `CI_ResponsibleParty` tag and its contents already; this
time I'll supply a "blank" version (and I'm leaving off fax. I'll leave
adding it back when necessary as an exercise for the reader).

    <gmd:pointOfContact>
      <gmd:CI_ResponsibleParty>

You only need supply one of `individualName`, `organisationName`, or
`positionName`; hopefully for this field we can supply an actual person.

        <gmd:individualName>
          <gco:CharacterString>Ada Lovelace</gco:CharacterString>
        </gmd:individualName>
        <gmd:organisationName gco:nilReason="missing">
          <gco:CharacterString/>
        </gmd:organisationName>
        <gmd:positionName gco:nilReason="missing">
          <gco:CharacterString/>
        </gmd:positionName>

        <gmd:contactInfo>
          <gmd:CI_Contact>
            <gmd:phone>
              <gmd:CI_Telephone>
                <gmd:voice gco:nilReason="missing">
                  <gco:CharacterString/>
                </gmd:voice>
              </gmd:CI_Telephone>
            </gmd:phone>
            <gmd:address>
              <gmd:CI_Address>
                <gmd:deliveryPoint gco:nilReason="missing">
                  <gco:CharacterString/>
                </gmd:deliveryPoint>
                <gmd:city gco:nilReason="missing">
                  <gco:CharacterString/>
                </gmd:city>
                <gmd:administrativeArea gco:nilReason="missing">
                  <gco:CharacterString/>
                </gmd:administrativeArea>
                <gmd:postalCode gco:nilReason="missing">
                  <gco:CharacterString/>
                </gmd:postalCode>
                <gmd:country gco:nilReason="missing">
                  <gco:CharacterString/>
                </gmd:country>
                <gmd:electronicMailAddress>
                  <gco:CharacterString>augusta.king@lovelace.gov.uk</gco:CharacterString>
                </gmd:electronicMailAddress>
              </gmd:CI_Address>
            </gmd:address>
          </gmd:CI_Contact>
        </gmd:contactInfo>

        <gmd:role>
          <gmd:CI_RoleCode
            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
            codeListValue="pointOfContact">
            pointOfContact
          </gmd:CI_RoleCode>
        </gmd:role>

      </gmd:CI_ResponsibleParty>
    </gmd:pointOfContact>


#### resourceMaintenance

You can optionally declare the intention to update the dataset.  This example
declares that updates are `notPlanned`, but you can change that to any of these
values:

- `continual` which in this context means "repeatedly and frequently"
- `hourly` only here because this list is also used for `samplingFrequency`
- `daily`
- `weekly`
- `fortnightly`
- `monthly`
- `quarterly`
- `biannually` twice a year (this word legitimately also means every two years,
  but not in this context)
- `annually`
- `asNeeded`
- `irregular`
- `notPlanned`
- `unknown`

If you're promising updates, there are additional properties allowed in the
`MD_MaintenanceInformation` tag describing stuff like the date of the next update,
the scope, the contact person for the update, etc. If I ever get a chance to use
those options I'll document them here.

    <gmd:resourceMaintenance>
      <gmd:MD_MaintenanceInformation>
        <gmd:maintenanceAndUpdateFrequency>
          <gmd:MD_MaintenanceFrequencyCode
            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_MaintenanceFrequencyCode"
            codeListValue="notPlanned"
          >notPlanned</gmd:MD_MaintenanceFrequencyCode>
        </gmd:maintenanceAndUpdateFrequency>
      </gmd:MD_MaintenanceInformation>
    </gmd:resourceMaintenance>


#### Thumbnails

You can optionally supply thumbnails for the dataset by providing
`graphicOverview` tags. Only the `fileName` tag is required inside
`graphicOverview > MD_BrowseGraphic`.

Samples here are from the ASDD example (which uses a full URL for the
thumbnail) and eAtlas (which uses a plain filename). I'm not sure how
GeoNetwork goes about locating the file.

TODO: investigate how GeoNetwork resolves thumbnail file paths.

    <gmd:graphicOverview>
      <gmd:MD_BrowseGraphic>
        <gmd:fileName>
          <gco:CharacterString>http://www.ga.gov.au/servlet/BigObjFileManager?bigobjid=GA3349</gco:CharacterString>
        </gmd:fileName>
        <gmd:fileDescription>
          <gco:CharacterString>Map index of Australia 1:1,000,000</gco:CharacterString>
        </gmd:fileDescription>
        <gmd:fileType>
          <gco:CharacterString>GIF</gco:CharacterString>
        </gmd:fileType>
      </gmd:MD_BrowseGraphic>
    </gmd:graphicOverview>

    <gmd:graphicOverview>
      <gmd:MD_BrowseGraphic>
        <gmd:fileName>
          <gco:CharacterString>Preview-map_s.png</gco:CharacterString>
        </gmd:fileName>
        <gmd:fileDescription>
          <gco:CharacterString>thumbnail</gco:CharacterString>
        </gmd:fileDescription>
        <gmd:fileType>
          <gco:CharacterString>png</gco:CharacterString>
        </gmd:fileType>
      </gmd:MD_BrowseGraphic>
    </gmd:graphicOverview>


#### Resource format

todo: work in progress (optional field)


#### Keywords

Keywords are optional, but strongly recommended by the AODN. They must be
selected from a
[NASA keyword list](http://gcmd.nasa.gov/Resources/valids/archives/keyword_list.html)
, and the MCP standard advises that the `thesaurusName` tag and its children
be supplied identifying the NASA list. The first example below shows the
recommended form; the second example is of two `keyword` tags from eAtlas
that do not include the thesaurus reference.

In addition to the thesaurus reference, each set of keywords can have a `type`
selected from another word list. The types are:

* `theme` is the subject or topic, and is the one you probably want most of
  the time
* `discipline` meaning a branch of study
* `place` a location
* `stratum` a deposited physical layer
* `temporal` names a time period (noting that
  [lunchtime is an illusion](http://www.goodreads.com/quotes/6344-time-is-an-illusion-lunchtime-doubly-so))
* `taxon` means "a taxonomy" according to `gmxCodelists.xml`, which must
  mean a specific taxon within a taxonomy (a species name, rather than the
  more silly interpretation of *taxonomy* as being "Linnaean" or something
  like that)
* `equipment` names gear used to collect data
* `dataSource` is described in `gmxCodelists.xml` as "identifies data source
  eg. aggregated/derived"

TODO: update the thesaurus reference to match JCU's GeoNetwork URLs.

    <gmd:descriptiveKeywords>
      <gmd:MD_Keywords>
        <gmd:keyword>
          <gco:CharacterString>Oceans | Marine Biology | Marine Mammals</gco:CharacterString>
        </gmd:keyword>
        <gmd:type>
          <gmd:MD_KeywordTypeCode
            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode"
            codeListValue="discipline"
          >discipline</gmd:MD_KeywordTypeCode>
        </gmd:type>
        <gmd:thesaurusName>
          <gmd:CI_Citation>
            <gmd:title>
              <gco:CharacterString>Global Change Master Directory Earth Science Keywords</gco:CharacterString>
            </gmd:title>
            <gmd:date gco:nilReason="unknown"/>
            <gmd:edition>
              <gco:CharacterString>bc44a748-f1a1-4775-9395-a4a6d8bb8df6:conceptscheme:GCMD Keywords, Version 5.3.8</gco:CharacterString>
            </gmd:edition>
            <gmd:editionDate gco:nilReason="unknown"/>
            <gmd:identifier>
              <gmd:MD_Identifier>
                <gmd:code>
                  <gmx:Anchor
                    xlink:href="http://yourgeonetwork.com/geonetwork/srv/en/?uuid=bc44a748-f1a1-4775-9395-a4a6d8bb8df6"
                  >
                    geonetwork.thesaurus.register.discipline.bc44a748-f1a1-4775-9395-a4a6d8bb8df6
                  </gmx:Anchor>
                </gmd:code>
              </gmd:MD_Identifier>
            </gmd:identifier>
            <gmd:otherCitationDetails>
              <gco:CharacterString>
                Olsen, L.M., G. Major, K. Shein,
                J. Scialdone, S. Ritz, T. Stevens, M. Morahan, A. Aleman,
                R. Vogel, S. Leicester, H. Weir, M. Meaux, S. Grebas,
                C.Solomon, M. Holland, T. Northcutt, R. A. Restrepo,
                R. Bilodeau,2012. NASA/Global Change Master Directory (GCMD)
                Earth Science Keywords
              </gco:CharacterString>
            </gmd:otherCitationDetails>
          </gmd:CI_Citation>
        </gmd:thesaurusName>
      </gmd:MD_Keywords>
    </gmd:descriptiveKeywords>

Example from eAtlas shows multiple keywords with a pipe separator; the ISO
standard allows multiple `keyword` tags, which is a more correct way to have
multiple keywords.

For eAtlas, the `marine` keyword is (AFACT) the trigger for AODN harvesting
of the record, which is probably why eAtlas don't include that particular
keyword in their idiosyncratic pipe separated list.

    <gmd:descriptiveKeywords>
      <gmd:MD_Keywords>
        <gmd:keyword>
          <gco:CharacterString>Oceans | Marine Biology | Marine Mammals</gco:CharacterString>
        </gmd:keyword>
        <gmd:type>
          <gmd:MD_KeywordTypeCode
            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode"
            codeListValue="theme"
          >theme</gmd:MD_KeywordTypeCode>
        </gmd:type>
      </gmd:MD_Keywords>
    </gmd:descriptiveKeywords>
    <gmd:descriptiveKeywords>
      <gmd:MD_Keywords>
        <gmd:keyword>
          <gco:CharacterString>marine</gco:CharacterString>
        </gmd:keyword>
        <gmd:type>
          <gmd:MD_KeywordTypeCode
            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode"
            codeListValue="theme"
          >theme</gmd:MD_KeywordTypeCode>
        </gmd:type>
      </gmd:MD_Keywords>
    </gmd:descriptiveKeywords>


#### Dataset usage

The standard allows a tag `resourceSpecificUsage` that can describe ways the
dataset has been used, allowing contact details to talk to the data users.
I haven't included this tag; refer to
[an ASDD sample](http://asdd.ga.gov.au/asdd/profileinfo/ANZCW0703008022testSchematron.xml)
for a usage example.


#### Constraints on the dataset

These constraints are usually related to copyright and licensing, but can also
include usage constraints like not appropriate for navigation, or national
security and secrecy constraints. The `resourceConstraints` tag is optional
(note that the AODN hinted that a licence will become mandatory at some point)
and can occur multiple times.

##### Plain copyright

This example from ASDD shows a standard copyright claim.

    <gmd:resourceConstraints>
      <gmd:MD_LegalConstraints>
        <gmd:useLimitation>
          <gco:CharacterString>Copyright Commonwealth of Australia (Geoscience Australia) 2008</gco:CharacterString>
        </gmd:useLimitation>
        <gmd:useConstraints>
          <gmd:MD_RestrictionCode
            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_RestrictionCode"
            codeListValue="copyright"
          >copyright</gmd:MD_RestrictionCode>
        </gmd:useConstraints>
      </gmd:MD_LegalConstraints>
    </gmd:resourceConstraints>


##### Creative Commons licences

MCP adds a constraint type `MD_Commons`, used to represent a licence
selected from a common licence set such as Creative Commons. This tag is
not mandatory, but the AODN user guide suggests that it may become mandatory
in a future version of the spec.

An attribute is required specifying the commons type (the two acceptable
values are `Creative Commons` and `Data Commons`). Four child tags are
mandatory inside a `MD_Commons` tag:

- `licenseName` a string naming the licence
- `licenseLink` a URL linking to the licence text
- `jurisdictionLink` a URL linking to jurisdiction information
- `imageLink` a URL linking to an image representing the licence

Additional optional `MD_Commons` child tags allow text describing constraints
in various areas.

- attributionConstraints
- derivativeConstraints
- commercialUseConstraints
- collectiveWorksConstraints
- otherConstraints

The `MD_Commons` tag can also include zero or more `useLimitation` tags.

This example is drawn from the
[MCP 1.4 docs](http://bluenet3.antcrc.utas.edu.au/mcp-doc/extensions/MD_Commons/index.html)
and shows a `MD_Commons` tag specifying the CC-BY-SA licence:

    <gmd:resourceConstraints>
      <mcp:MD_Commons mcp:commonsType="Creative Commons" gco:isoType="gmd:MD_Constraints">
        <gmd:useLimitation>
          <gco:CharacterString>
            The data used to test this vehicle should not be
            used for navigation purposes
          </gco:CharacterString>
        </gmd:useLimitation>
        <mcp:jurisdictionLink>
          <gmd:URL>http://creativecommons.org/international/au/</gmd:URL>
        </mcp:jurisdictionLink>
        <mcp:licenseLink>
          <gmd:URL>http://creativecommons.org/licenses/by-sa/3.0/au/</gmd:URL>
        </mcp:licenseLink>
        <mcp:imageLink>
          <gmd:URL>http://i.creativecommons.org/l/by-sa/3.0/au/88x31.png</gmd:URL>
        </mcp:imageLink>
        <mcp:licenseName>
          <gco:CharacterString>Attribution-ShareAlike 3.0 Australia</gco:CharacterString>
        </mcp:licenseName>
        <mcp:attributionConstraints>
          <gco:CharacterString>
            Attribute as: Butte J, A horse drawn, cabbage leaf powered,
            marine bicycle, Heath Robinson Monthly, UK Oceanographics Inc
          </gco:CharacterString>
        </mcp:attributionConstraints>
        <mcp:otherConstraints>
          <gco:CharacterString>
            Note attribution and share alike provisions of CC license
          </gco:CharacterString>
        </mcp:otherConstraints>
      </mcp:MD_Commons>
    </gmd:resourceConstraints>

The following example shows a CC-BY license, the default licence for Australian
Government Departments and Agencies. According to the current Australian
copyright body [AUSGOAL](http://www.ausgoal.gov.au/creative-commons):

> This licence lets others distribute, remix, tweak, and build upon your
> work, even commercially, as long as they credit you for the original
> creation. This is the most accommodating of licences offered. Recommended
> for maximum dissemination and use of licensed materials.

    <gmd:resourceConstraints>
      <mcp:MD_Commons mcp:commonsType="Creative Commons" gco:isoType="gmd:MD_Constraints">
        <mcp:jurisdictionLink>
          <gmd:URL>http://creativecommons.org/international/au/</gmd:URL>
        </mcp:jurisdictionLink>
        <mcp:licenseLink>
          <gmd:URL>http://creativecommons.org/licenses/by/3.0/au/deed.en</gmd:URL>
        </mcp:licenseLink>
        <mcp:imageLink>
          <gmd:URL>http://i.creativecommons.org/l/by/3.0/au/88x15.png</gmd:URL>
        </mcp:imageLink>
        <mcp:licenseName>
          <gco:CharacterString>Attribution-ShareAlike 3.0 Australia</gco:CharacterString>
        </mcp:licenseName>
        <mcp:attributionConstraints>
          <gco:CharacterString>
            Attribute as: Butte J, A horse drawn, cabbage leaf powered,
            marine bicycle, Heath Robinson Monthly, UK Oceanographics Inc
          </gco:CharacterString>
        </mcp:attributionConstraints>
        <mcp:otherConstraints>
          <gco:CharacterString>
            Note attribution and share alike provisions of CC license
          </gco:CharacterString>
        </mcp:otherConstraints>
      </mcp:MD_Commons>
    </gmd:resourceConstraints>


##### Non-CC licences

This example by [Steven Vandervalk](steven.vandervalk@jcu.edu.au) shows a
[CC-Zero](https://creativecommons.org/about/cc0/) license, intended to allow
rights holders to waive their copyright to a work. Definitely **delete this
section** unless the author/owner has clearly confirmed their intention to put
their work into the public domain.

Although CC0 is almost a CC licence, this example is using the generic licence
(`useConstraints`) format and can be adapted to capture a non-CC licence.

    <gmd:resourceConstraints>
      <gmd:MD_LegalConstraints>
        <gmd:useLimitation>
          <gco:CharacterString>
            http://i.creativecommons.org/p/zero/1.0/88x31.png
            This product is released under the
            Creative Commons Zero Licence
            (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
          </gco:CharacterString>
        </gmd:useLimitation>
        <gmd:useConstraints>
          <gmd:MD_RestrictionCode
            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_RestrictionCode"
            codeListValue="license"
          >copyright</gmd:MD_RestrictionCode>
        </gmd:useConstraints>
      </gmd:MD_LegalConstraints>
    </gmd:resourceConstraints>


#### Aggregation information

todo: work in progress (optional)


#### Language and character set for the data

These are the same tags as before, but this time they're describing the
language and character set of the *dataset itself*.

    <gmd:language>
      <gco:CharacterString>eng</gco:CharacterString>
    </gmd:language>
    <gmd:characterSet>
      <gmd:MD_CharacterSetCode
        codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"
        codeListValue="utf8"
      >utf8</gmd:MD_CharacterSetCode>
    </gmd:characterSet>


#### Topic

Topic is mandatory. It classifies the "theme" of the data (or "themes", as
you can have several of this tag) and should be drawn from [the
MD_TopicCategoryCode
list](https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_TopicCategoryCode),
although in this case there is no need for a reference to the codelist URL.

Datasets destined for the AODN should use `oceans`. Other alternatives are:

- `biota`
- `climatologyMeteorologyAtmosphere`, `environment`
- `boundaries`, `planningCadastre`, `location`
- `economy`, `farming`, `health`, `society`
- `elevation`, `geoscientificInformation`
- `imageryBaseMapsEarthCover`
- `intelligenceMilitary`
- `inlandWaters`
- `structure`, `transportation`, `utilitiesCommunication`

The `gmxCodeLists.xml` document includes definitions of these terms if you
need help deciding.

    <gmd:topicCategory>
      <gmd:MD_TopicCategoryCode>oceans</gmd:MD_TopicCategoryCode>
    </gmd:topicCategory>


#### Spatial and temporal extent of the data

This mandatory element describes what the data covers, both via a bounding box
or bounding polygon, in altitude and depth, and in time.

There are four allowable child tags for the `EX_Extent` tag, each one a
different flavour of extent:

- `geographicElement`
- `temporalElement`
- `verticalElement`
- `description`

MCP2 **requires** at least a `geographicElement` containing a bounding box
and a temporal extent with start and end dates.

It's valid to include multiple `extent` tags, and each one can contain several
flavours, including (as far as I can tell) the same flavour multiple times.

It's not well described in the spec, but I think the intention is when a
single `extent` tag includes a single temporal extent and three different
geographic extents, then the time period applies to all three geo extents.

However if the data covers three geo extents at differing time periods, you
should supply three `extent` tags, each one describing an area and its
corresponding time period.

    <gmd:extent>
      <gmd:EX_Extent>


##### Geographic flavour

This example includes various `geographicElement` types. The west and east
bounds are required to be in the range -180 to 180, so a bounding box spanning
the dateline will have `westBoundLongitude` > `eastBoundLongitude`.

        <gmd:geographicElement>
          <gmd:EX_GeographicBoundingBox>
            <gmd:westBoundLongitude>
              <gco:Decimal>142.83</gco:Decimal>
            </gmd:westBoundLongitude>
            <gmd:eastBoundLongitude>
              <gco:Decimal>152.23</gco:Decimal>
            </gmd:eastBoundLongitude>
            <gmd:southBoundLatitude>
              <gco:Decimal>-24.5</gco:Decimal>
            </gmd:southBoundLatitude>
            <gmd:northBoundLatitude>
              <gco:Decimal>-11.5</gco:Decimal>
            </gmd:northBoundLatitude>
          </gmd:EX_GeographicBoundingBox>
        </gmd:geographicElement>

Polygons are supported. The example below is taken from the ASDD sample
document, but I've removed an initial blank `pos` (it stopped GeoNetwork
from displaying the polygon at all) and I've switched the `srsName` from
`EPSG::4283` (an Australian-continent-focused SRS) to `EPSG:4326` (common ol'
WGS84). The original value confused GeoNetwork into swapping lats and longs
(or possibly that SRS actually uses lng-lat, and the original polygon author
got it wrong).

GML lets you specify interior rings (for holes in your coverage polygon), so
good luck with the [GML standard](http://www.opengeospatial.org/standards/gml).

You can specify multiple bounding boxes or multiple polygons by repeating
the `geographicElement` tag. GML objects (like `Polygon`) require an `id`
attribute; if you have multiples, remember to use unique `id`s.

        <gmd:geographicElement>
          <gmd:EX_BoundingPolygon>
            <gmd:polygon>
              <gml:Polygon gml:id="p1" srsName="EPSG:4326" uomLabels="degree">
                <gml:exterior>
                  <gml:LinearRing>
                    <gml:pos>-8 92</gml:pos>
                    <gml:pos>-60 85</gml:pos>
                    <gml:pos>-80 153</gml:pos>
                    <gml:pos>-8 172</gml:pos>
                    <gml:pos>-40 120</gml:pos>
                    <gml:pos>-8 92</gml:pos>
                  </gml:LinearRing>
                </gml:exterior>
              </gml:Polygon>
            </gmd:polygon>
          </gmd:EX_BoundingPolygon>
        </gmd:geographicElement>


##### Temporal flavour

The temporal element content is custom to MCP since MCP 1.2, and allows an
optional `currency` tag to indicate how current the data are, selected from
these values:

- `mostRecent`
- `historical`
- `predicted`
- `unknown`

and an optional `temporalAggregation` tag to indicate the time unit that the
dataset is aggregated by, selected from these values:

- `day`
- `three-day`
- `six-day`
- `multi-day`
- `week`
- `month`
- `multi-month`
- `year`
- `multi-year`
- `none`

The weirdly specific `three-day` and `six-day` values are new to MCP2.0 (in
fact they are present only in the codeList source and not mentioned in any
public MCP2 documentation, but I asked a MCP person and they're official).

GML "objects" (which doesn't mean every gml tag) need `id`s, so
remember to add those where indicated.

        <gmd:temporalElement>
          <mcp:EX_TemporalExtent gco:isoType="gmd:EX_TemporalExtent">
            <gmd:extent>
              <gml:TimePeriod gml:id="N10315">
                <gml:begin>
                  <gml:TimeInstant gml:id="N1031B">
                    <gml:timePosition>2012-01-01T00:45:00</gml:timePosition>
                  </gml:TimeInstant>
                </gml:begin>
                <gml:end>
                  <gml:TimeInstant gml:id="N10326">
                    <gml:timePosition>2012-01-28T03:30:00</gml:timePosition>
                  </gml:TimeInstant>
                </gml:end>
              </gml:TimePeriod>
            </gmd:extent>
            <mcp:currency>
              <mcp:MD_CurrencyTypeCode
                codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_CurrencyTypeCode"
                codeListValue="historical"
              >historical</mcp:MD_CurrencyTypeCode>
            </mcp:currency>
            <mcp:temporalAggregation>
              <mcp:MD_TemporalAggregationUnitCode
                codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_TemporalAggregationUnitCode"
                codeListValue="week"
              >week</mcp:MD_TemporalAggregationUnitCode>
            </mcp:temporalAggregation>
          </mcp:EX_TemporalExtent>
        </gmd:temporalElement>


##### Vertical flavour

((TODO: expand this section))

Vertical extents need minimum and maximum values, and to specify a
`verticalCRS` to describe what crazy units you're using and if more
negative means further toward the Earth's core, or further away.

        <gmd:verticalElement>
          <gmd:EX_VerticalExtent>

Min and max values are the quick bit.

            <gmd:minimumValue>
              <gco:Real>-5625</gco:Real>
            </gmd:minimumValue>
            <gmd:maximumValue>
              <gco:Real>2848</gco:Real>
            </gmd:maximumValue>

Now the `verticalCRS > VerticalCRS`.  Watch out for these parts:

- `identifier` is the coordinate reference system for your vertical
  measure.  You probably want `5714` or `5715` for a world-over
  metres from mean sea level or "msl".  Use `5714` for *height* from
  MSL (negative means underwater) and `5715` for *depth* (positive
  means underwater)
- `... > VerticalCS > identifier` is the coordinate system for your
  vertical measure.  Use `6499` to refer to units of *metres* and
  an orientation of *up*.  Use `6498` for metres down.  Use this 🔫
  if you can't stand specifying the same thing over and over any
  more


            <gmd:verticalCRS>
              <gml:VerticalCRS gml:id="gmlvcrs">
                <gml:identifier codeSpace="urn:ogc:def:cs:EPSG::">5714</gml:identifier>
                <gml:scope>Australia</gml:scope>
                <gml:usesVerticalCS>
                  <gml:VerticalCS gml:id="gmlvcs">
                    <gml:identifier codeSpace="urn:ogc:def:cs:EPSG::">6499</gml:identifier>

This `CoordinateSystemAxis` tag specifies `uom="m"` to specify metres
again, and describes EPSG:5711 which is the Australian height datum
or "AHD", and finally specifies again that "up" is the direction in
which data numbers will increase.

                      <gml:axis>
                        <gml:CoordinateSystemAxis gml:id="gmlcsa" gml:uom="m">
                          <gml:identifier codeSpace="urn:ogc:def:axis:EPSG::">5711</gml:identifier>
                          <gml:axisAbbrev>AHD</gml:axisAbbrev>
                          <gml:axisDirection codeSpace="urn:ogc:def:axisDirection:EPSG::">up</gml:axisDirection>
                        </gml:CoordinateSystemAxis>
                      </gml:axis>

                  </gml:VerticalCS>
                </gml:usesVerticalCS>

Now we can specify the datum, which we already said was MSL but needs
saying again.

                <gml:verticalDatum>
                  <gml:VerticalDatum gml:id="gmlvd">
                    <gml:identifier codeSpace="urn:ogc:def:cs:EPSG::">5100</gml:identifier>
                    <gml:name>mean sea level</gml:name>
                    <gml:scope>World</gml:scope>
                  </gml:VerticalDatum>
                </gml:verticalDatum>

Finally, close all the things.

              </gml:VerticalCRS>
            </gmd:verticalCRS>
          </gmd:EX_VerticalExtent>
        </gmd:verticalElement>


##### Description flavour

Before I show you a description type of `geographicElement`, I'll close the
current `extent` tag, and open a new one. I can't find a reference in any
implementation guides, but GeoNetwork seems to choke if a description is
present with a bounding box.

TODO: check GeoNetwork's tolerance of various tag combinations inside a
single `extent`.

      </gmd:EX_Extent>
    </gmd:extent>
    <gmd:extent>
      <gmd:EX_Extent>

Now I can include a description-type geographic identifier.

This flavour supports a textual description of the geographic extent, for
example a state name such as "Queensland" (which you'd actually need to write
as `QLD`). This section is surprisingly verbose; I'll indicate the bits you
need to change. (Also, since it takes tags nested nine or ten deep to say a
location name, I've reset indenting for this section.)

    <gmd:geographicElement>
      <gmd:EX_GeographicDescription>
        <gmd:geographicIdentifier>
          <gmd:MD_Identifier>
            <gmd:authority>
              <gmd:CI_Citation id="mcpgenr">
                <gmd:title>
                  <gco:CharacterString>MCP Geographic Extent Name Register 2.0</gco:CharacterString>
                </gmd:title>
                <gmd:date>
                  <gmd:CI_Date>
                    <gmd:date>
                      <gco:Date>2006-10-10</gco:Date>
                    </gmd:date>
                    <gmd:dateType>
                      <gmd:CI_DateTypeCode
                        codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                        codeListValue="revision"
                      >revision</gmd:CI_DateTypeCode>
                    </gmd:dateType>
                  </gmd:CI_Date>
                </gmd:date>
                <gmd:edition>
                  <gco:CharacterString>Version 2</gco:CharacterString>
                </gmd:edition>

I originally tried to use a date of `2001-02`, but GeoNetwork's UI didn't like
it.

                <gmd:editionDate>
                  <gco:Date>2001-02-01</gco:Date>
                </gmd:editionDate>
                <gmd:identifier>
                  <gmd:MD_Identifier>
                    <gmd:code>

Note that this Codelist URL has a different filename than the
`gmxCodelists.xml` used elsewhere, and also that the specifier after
the `#` should indicate the region list you're selecting your region from.

TODO: confirm that `mcp-allgens.xml` is actually available at this URL.

                      <gco:CharacterString>http://schemas.aodn.org.au/mcp-2.0/schema/resources/Codelist/mcp-allgens.xml#anzlic-state_territory</gco:CharacterString>
                    </gmd:code>
                  </gmd:MD_Identifier>
                </gmd:identifier>
              </gmd:CI_Citation>
            </gmd:authority>
            <gmd:code>

The following string is the actual reference code for the region.

              <gco:CharacterString>ACT</gco:CharacterString>
            </gmd:code>
          </gmd:MD_Identifier>
        </gmd:geographicIdentifier>
      </gmd:EX_GeographicDescription>
    </gmd:geographicElement>

Here's a list of some useful region types and codes; look inside a copy of
`mcp-allgens.xml` for a complete list.

- **`#anzlic-australia`**: `AUS` for Australia, `AUSAAT` for Australia and external territories.
- **`#anzlic-state_territory`**: `ACT`, `NSW`, `NT`, `QLD`, `SA`, `TAS`, `VIC`, `WA`
- **`#anzlic-imcra`**: The meso-scale
  [IMCRA](http://www.environment.gov.au/node/18075) bioregions, using standard
  IMCRA codes that you can find on
  [this PDF map](http://www.environment.gov.au/system/files/resources/2660e2d2-7623-459d-bcab-1110265d2c86/files/map2-msb.pdf).
- **`#anzlic-ocean_sea`**: `ARAFURA_SEA`, `CORAL_SEA`, `GREAT_BARRIER_REEF`,
  `TORRES_STRAIT`, etc
- **`anzlic-ocean_sea`** also has GBR sections:
  - `GREAT_BARRIER_REEF___CAIRNS_SECTION`
  - `GREAT_BARRIER_REEF___CAPRICORN_BUNKER_GROUP`
  - `GREAT_BARRIER_REEF___CENTRAL_SECTION`
  - `GREAT_BARRIER_REEF___FAR_NORTHERN_SECTION`
  - `GREAT_BARRIER_REEF___MACKAY_SECTION`


(End of the extent.)

      </gmd:EX_Extent>
    </gmd:extent>


#### Sampling frequency

(TODO Work in progress)

A record of the frequency at which a dataset is sampled.  Note that there is a
separate place to record the aggregation period, so this tag should used to
represent the period between multiple reported data points.

Note that the `MD_MaintenanceFrequencyCode` tag is identical to that used in the
section on resource maintenance frequency, so refer to that for a full list of
values, but you'll usually want one of `hourly`, `daily`, `weekly`, `annually`,
`asNeeded`, or `irregular`.


     <mcp:samplingFrequency>
      <gmd:MD_MaintenanceFrequencyCode
        codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_MaintenanceFrequencyCode"
        codeListValue="asNeeded"
      >asNeeded</gmd:MD_MaintenanceFrequencyCode>
    </mcp:samplingFrequency>


#### Data parameters

MCP2 adds the ability to describe parameters of the dataset. This is optional
but is required for the AODN portal's faceted navigation via *Parameter* and
*Platform*.  You can't have more than one list.

The structure is basically a list of `dataParameter` tags, each describing one
of the data parameters within the dataset. There's afair bit of the *thing* >
*XY_Thing* double-nesting you see elsewhere in iso19139.

Starting the list of params:

    <mcp:dataParameters>
      <mcp:DP_DataParameters>

Here's a single parameter. It *must* have a name and units; it can optionally
have min and max values, and the instrument(s), analysis method(s), and
platform(s) used to measure/obtain/determine the parameter's values.

Most of these are expressed as `DP_Term` tags, which allows controlled
vocabularies. I'm not including examples of the following tags, but they are
all containers for `DP_Term` tags, so you can copy `mcp:parameterUnit` to get
started.

- `mcp:parameterDeterminationInstrument`
- `mcp:parameterAnalysisMethod`
- `mcp:platform`

Starting a single parameter:

        <mcp:dataParameter>
          <mcp:DP_DataParameter>


##### Parameter name, type, and "used"ness

The parameter has a `parameterName`, which is a `DP_Term` type. The name
must include `term`, `type`, and `usedInDataset`. It must include either a
`termDefinition` or some `vocabularyRelationship`s.

The `parameterName` is what you call the parameter. You must have at least
one, and you can have multiple of these for a single parameter, which lets
you express synonyms.

            <mcp:parameterName>
              <mcp:DP_Term>

The `term` is what the parameter is called. The `type` can be one of:

- `shortName` requires a `vocabularyTermURL`.
- `longName` requires a `vocabularyTermURL`.
- `localSynonym` requires a `termDefinition`.
- `localCode` requires a `termDefinition`.



                <mcp:term>
                  <gco:CharacterString>
                    Temperature of the water body
                  </gco:CharacterString>
                </mcp:term>
                <mcp:type>
                  <mcp:DP_TypeCode
                    codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#DP_TypeCode"
                    codeListValue="longName"
                  >longName</mcp:DP_TypeCode>
                </mcp:type>

It's hard to think of good reasons you would describe a parameter that is
not used in the the dataset, but if you did, you should set `usedInDataset`
to false.

                <mcp:usedInDataset>
                  <gco:Boolean>true</gco:Boolean>
                </mcp:usedInDataset>


##### Defining the parameter: official vocabularies

You can claim zero or more corresponding vocab term in an official
vocabulary, presumably from one of these ANDS pages:

- https://vocabs.ands.org.au/aodn-units-of-measure-vocabulary
- https://vocabs.ands.org.au/aodn-discovery-parameter-vocabulary

If you're using a `shortName` or `longName`, the minimum you need to supply
is a `vocabularyTermURL`.

Adapt this url to match the one for your vocab term:

                <mcp:vocabularyTermURL>
                  <gmd:URL>http://vocab.nerc.ac.uk/collection/P01/current/TEMPPR01</gmd:URL>
                </mcp:vocabularyTermURL>

These descriptions of the vocab publisher, version, and service URL are
probably already correct:

                <mcp:vocabularyTermPublisher>
                  <gmd:CI_Citation>
                    <gmd:title>
                      <gco:CharacterString>AODN Discovery Parameter Vocabulary</gco:CharacterString>
                    </gmd:title>
                    <gmd:date>
                      <gmd:CI_Date>
                        <gmd:date>
                          <gco:Date>2015-09-01</gco:Date>
                        </gmd:date>
                        <gmd:dateType>
                          <gmd:CI_DateTypeCode
                            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                            codeListValue="creation"
                          >creation</gmd:CI_DateTypeCode>
                        </gmd:dateType>
                      </gmd:CI_Date>
                    </gmd:date>
                    <gmd:citedResponsibleParty>
                      <gmd:CI_ResponsibleParty>
                        <gmd:organisationName>
                          <gco:CharacterString>eMarine Information Infrastructure (eMII)</gco:CharacterString>
                        </gmd:organisationName>
                        <gmd:role>
                          <gmd:CI_RoleCode
                            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                            codeListValue="publisher"
                          >publisher</gmd:CI_RoleCode>
                        </gmd:role>
                      </gmd:CI_ResponsibleParty>
                    </gmd:citedResponsibleParty>
                  </gmd:CI_Citation>
                </mcp:vocabularyTermPublisher>

                <mcp:vocabularyServiceURL>
                  <gmd:URL>http://vocabs.ands.org.au/repository/api/lda/aodn/aodn-discoveryparameter-vocabulary/version-1-0/concept</gmd:URL>
                </mcp:vocabularyServiceURL>

                <mcp:vocabularyVersion>
                  <gco:CharacterString>1.0</gco:CharacterString>
                </mcp:vocabularyVersion>

You can have zero or more `vocabularyRelationship`s, which define connections
between this data parameter and other vocab words. The allowable
`DP_RelationshipTypeCode` values are:

- `skos:exactmatch` vocab term is an exact match for the local term
- `skos:closematch` vocab term is a close match to the local term
- `skos:narrowmatch` vocab term is narrower in definition than the local term
- `skos:broadmatch` vocab term is broader in definition than the local term


                <mcp:vocabularyRelationship>
                  <mcp:DP_VocabularyRelationship>
                    <mcp:relationshipType>
                      <mcp:DP_RelationshipTypeCode
                        codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#DP_RelationshipTypeCode"
                        codeListValue="skos:closematch"
                      >skos:closematch</mcp:DP_RelationshipTypeCode>
                    </mcp:relationshipType>
                    <mcp:relatedTermURL>
                      <gmd:URL>http://gcmdservices.gsfc.nasa.gov/kms/concept/61594015-4ab4-4b38-ae4f-e31a4757b065</gmd:URL>
                    </mcp:relatedTermURL>
                    <mcp:relatedTerm>
                      <gco:CharacterString>Water Temperature</gco:CharacterString>
                    </mcp:relatedTerm>
                  </mcp:DP_VocabularyRelationship>
                </mcp:vocabularyRelationship>



##### Defining the parameter: local definition

Instead of a `vocabularyTermURL`, you can choose to supply a simple
definition (technically you can have both, but you must have one or the other,
and which one you require depends on the `type` you gave this parameter).

I don't have an example, but I think it would look like this:

                <mcp:termDefinition>
                  <gco:CharacterString>
                    Estimated value of conservation in an area
                    to long term survival of dugongs.
                  </gco:CharacterString>
                </mcp:termDefinition>

Note that the scale, which might be something like "0 to 4: 0 = no
conservation value, 4 = high conservation value", is not described here;
that should (I think) be discussed in the `parameterUnits` tag below.

(End of the parameter name.)

              </mcp:DP_Term>
            </mcp:parameterName>


##### Units of the parameter's values

The `term`, `type` and `usedInDataset` are similar to the previous section.

            <mcp:parameterUnits>
              <mcp:DP_Term>
                <mcp:term>
                  <gco:CharacterString>degrees celsius</gco:CharacterString>
                </mcp:term>
                <mcp:type>
                  <mcp:DP_TypeCode
              codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#DP_TypeCode"
              codeListValue="longName">longName</mcp:DP_TypeCode>
                </mcp:type>
                <mcp:usedInDataset>
                  <gco:Boolean>true</gco:Boolean>
                </mcp:usedInDataset>


For most units you should be able to identify a `skos:exactmatch` vocab term.

                <mcp:vocabularyTermURL>
                  <gmd:URL>http://vocab.nerc.ac.uk/collection/P06/current/UPAA</gmd:URL>
                </mcp:vocabularyTermURL>

Same publisher as before.

                <mcp:vocabularyTermPublisher>
                  <gmd:CI_Citation>
                    <gmd:title>
                      <gco:CharacterString>AODN Discovery Parameter Vocabulary</gco:CharacterString>
                    </gmd:title>
                    <gmd:date>
                      <gmd:CI_Date>
                        <gmd:date>
                          <gco:Date>2015-09-01</gco:Date>
                        </gmd:date>
                        <gmd:dateType>
                          <gmd:CI_DateTypeCode
                            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                            codeListValue="creation"
                          >creation</gmd:CI_DateTypeCode>
                        </gmd:dateType>
                      </gmd:CI_Date>
                    </gmd:date>
                    <gmd:citedResponsibleParty>
                      <gmd:CI_ResponsibleParty>
                        <gmd:organisationName>
                          <gco:CharacterString>eMarine Information Infrastructure (eMII)</gco:CharacterString>
                        </gmd:organisationName>
                        <gmd:role>
                          <gmd:CI_RoleCode
                            codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                            codeListValue="publisher"
                          >publisher</gmd:CI_RoleCode>
                        </gmd:role>
                      </gmd:CI_ResponsibleParty>
                    </gmd:citedResponsibleParty>
                  </gmd:CI_Citation>
                </mcp:vocabularyTermPublisher>

                <mcp:vocabularyServiceURL>
                  <gmd:URL>http://vocabs.ands.org.au/repository/api/lda/aodn/aodn-units-of-measure-vocabulary/version-1-0/concept</gmd:URL>
                </mcp:vocabularyServiceURL>

                <mcp:vocabularyVersion>
                  <gco:CharacterString>1.0</gco:CharacterString>
                </mcp:vocabularyVersion>

                <mcp:termDefinition>
                  <gco:CharacterString>Some definition for degrees celsius</gco:CharacterString>
                </mcp:termDefinition>

              </mcp:DP_Term>
            </mcp:parameterUnits>



##### Parameter min and max values, and description

These are all simple strings.

            <mcp:parameterMinimumValue>
              <gco:CharacterString>2.1</gco:CharacterString>
            </mcp:parameterMinimumValue>
            <mcp:parameterMaximumValue>
              <gco:CharacterString>18.2</gco:CharacterString>
            </mcp:parameterMaximumValue>

(End of data parameter.)

          </mcp:DP_DataParameter>
        </mcp:dataParameter>


(End of data parameter list.)

      </mcp:DP_DataParameters>
    </mcp:dataParameters>



(End of identification info, and restoring original indent level)

        </mcp:MD_DataIdentification>
      </gmd:identificationInfo>


### Distribution info

This is an optional section of the XML, describing how, where, and from
whom the data is available.

      <gmd:distributionInfo>
        <gmd:MD_Distribution>

The `MD_Distribution` tag is required to include a `distributionFormat` and/or
a `distributorFormat`. ANZLIC recommends `distributorFormat`.

The `MD_Distribution` tag may also include `transferOptions` tags that
describe ways to get the data -- both online methods like download links and
URLs to a WMS server, and offline techniques like ordering DVDs or paper maps.


#### Distribution format

This describes the file format, or as the ANZLIC standard eloquently puts
it, "the computer language construct that specifies the representation of
data objects in a record, file, message, storage device or transmission
channel".

eAtlas dodges the requirement for distribution or distributor information
by including this tag with no content:

          <gmd:distributionFormat>
            <gmd:MD_Format>
              <gmd:name gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:name>
              <gmd:version gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:version>
            </gmd:MD_Format>
          </gmd:distributionFormat>

Here are additional `distributionFormat` examples; delete the ones you don't
want. The ANZLIC sample prefixes all the format descriptions with the string
"DIGITAL - ", but the standard says it should be a "concise title" for the
format, so I'm not using a prefix for digital file formats.

The ANZLIC standard's recommended technique for not supplying a version
number is to claim `nilReason="inapplicable"`, but the ANZLIC sample file
used a literal value of `none` instead. I've included both strategies in
these examples; using `none` is a little more acceptable to GeoNetwork's
edit pages.

##### ASCII grid using lat / long

          <gmd:distributionFormat>
            <gmd:MD_Format>
              <gmd:name>
                <gco:CharacterString>ESRI ASCII grid Geographic WGS84</gco:CharacterString>
              </gmd:name>
              <gmd:version gco:nilReason="inapplicable"/>
            </gmd:MD_Format>
          </gmd:distributionFormat>


##### ASCII grid without specifying projection

          <gmd:distributionFormat>
            <gmd:MD_Format>
              <gmd:name>
                <gco:CharacterString>ESRI ASCII grid</gco:CharacterString>
              </gmd:name>
              <gmd:version>
                <gco:CharacterString>none</gco:CharacterString>
              </gmd:version>
            </gmd:MD_Format>
          </gmd:distributionFormat>


##### Shapefile

          <gmd:distributionFormat>
             <gmd:MD_Format>
                <gmd:name>
                   <gco:CharacterString>ESRI Shapefile</gco:CharacterString>
                </gmd:name>
                <gmd:version gco:nilReason="inapplicable"/>
             </gmd:MD_Format>
          </gmd:distributionFormat>


#### Distributor

This distributor example comes from an ASDD sample record. Although
recommended by ANZLIC, this tag doesn't appear in eAtlas or the MCP2 minsample,
and I suspect is less relevant in a world where actually getting the dataset
is built in to the metadata browsing platform. Hence I'm just including the
ASDD sample tag verbatim for your edification, leaving any adaptation as an
exercise for the reader -- don't forget to set the `fees` tag appropriately.

          <gmd:distributor>
            <gmd:MD_Distributor>
              <gmd:distributorContact>
                <gmd:CI_ResponsibleParty>
                  <gmd:organisationName>
                    <gco:CharacterString>Geoscience Australia</gco:CharacterString>
                  </gmd:organisationName>
                  <gmd:role>
                    <gmd:CI_RoleCode
                      codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                      codeListValue="custodian"
                    >custodian</gmd:CI_RoleCode>
                  </gmd:role>
                </gmd:CI_ResponsibleParty>
              </gmd:distributorContact>
              <gmd:distributionOrderProcess gco:nilReason="withheld">
                <gmd:MD_StandardOrderProcess>
                  <gmd:fees>
                    <gco:CharacterString>Charge as much as they will spend.</gco:CharacterString>
                  </gmd:fees>
                  <gmd:plannedAvailableDateTime>
                    <gco:DateTime>2008-08-08T13:00:00</gco:DateTime>
                  </gmd:plannedAvailableDateTime>
                </gmd:MD_StandardOrderProcess>
              </gmd:distributionOrderProcess>
              <gmd:distributorFormat>
                <gmd:MD_Format>
                  <gmd:name>
                    <gco:CharacterString>DIGITAL - ermapper ERMapper dataset file Geographic WGS84</gco:CharacterString>
                  </gmd:name>
                  <gmd:version>
                    <gco:CharacterString>None</gco:CharacterString>
                  </gmd:version>
                </gmd:MD_Format>
              </gmd:distributorFormat>
              <gmd:distributorTransferOptions>
                <gmd:MD_DigitalTransferOptions>
                  <gmd:offLine>
                    <gmd:MD_Medium>
                      <gmd:density>
                        <gco:Real>12</gco:Real>
                      </gmd:density>
                      <gmd:densityUnits>
                        <gco:CharacterString>metre</gco:CharacterString>
                      </gmd:densityUnits>
                    </gmd:MD_Medium>
                  </gmd:offLine>
                </gmd:MD_DigitalTransferOptions>
              </gmd:distributorTransferOptions>
            </gmd:MD_Distributor>
          </gmd:distributor>


#### How to get the dataset

Here are the `transferOptions` mentioned before. eAtlas and the minsample from
GeoNetwork use a single `transferOptions` tag that contains a single
`MD_DigitalTransferOptions` tag, that contains multiple `onLine` tags. The
ASDD example uses multiple `transferOptions` tags. Here I'm including the
single wrapping set of tags from eAtlas.

          <gmd:transferOptions>
            <gmd:MD_DigitalTransferOptions>
              <gmd:onLine>
                <gmd:CI_OnlineResource>


The `linkage` tag is required to contain a URL that conforms to
[RFC1738](https://www.ietf.org/rfc/rfc1738.txt) (normal URLs) and
[RFC2056](https://www.ietf.org/rfc/rfc2056.txt) (querying via URLs).

                  <gmd:linkage>
                    <gmd:URL>http://maps.eatlas.org.au/maps/wms</gmd:URL>
                  </gmd:linkage>


The `protocol` looks like a standardised string, but AFAICT it's not a
restricted list, and the set of common values is just defined by GeoNetwork.

The ANZLIC standard uses `HTTP` as its example. The MCP examples I've seen
used included:

- `WWW:LINK-1.0-http--link` for a plain ol' link. eAtlas use this to link to
  the ePrints URL for the data's corresponding article, and the article title
  is used in the `description` tag.
- `WWW:LINK-1.0-http--metadata-URL` for a link to a metadata record. eAtlas
  use this to link to a nice "point-of-truth" human readable page rather than
  their GeoNetwork.
- `OGC:WMS-1.1.1-http-get-map` for the WMS URL. The layer name (which for
  GeoServer will include the namespace code and colon as a prefix) should be
  supplied as the `name`.
- `WWW:LINK-1.0-http--related` for a related link. eAtlas use that to link to
  the service record for their whole eAtlas mapping site. This is probably a
  good strategy for giving the user some ability to do their own searching.
- `WWW:DOWNLOAD-1.0-http--downloaddata` for a link to get data. I don't know
  when you would use this vs the WWW:LINK...downloaddata version.
- `OGC:SOS-1.0.0-http-post-observation`
- `OGC:WMC-1.1.0-http-get-capabilities`
- `WWW:DOWNLOAD-1.0-http--download`
- `WWW:LINK-1.0-http--downloaddata`


                  <gmd:protocol>
                    <gco:CharacterString>OGC:WMS-1.1.1-http-get-map</gco:CharacterString>
                  </gmd:protocol>

The `name` is the actual identifying name for the thing linked to. For WMS
layers coming from GeoServer, the layer name should be prefixed with namespace
and a colon.

                  <gmd:name>
                    <gco:CharacterString>ea:GBR_MTSRF_Grech_JCU_Dugong-dist-1986-2005</gco:CharacterString>
                  </gmd:name>

The `description` describes what's linked to. eAtlas puts article titles here
when linking to articles in ePrints or elsewhere. You can describe file
formats here too.


                  <gmd:description>
                    <gco:CharacterString>WMS layer of this dataset</gco:CharacterString>
                  </gmd:description>
                </gmd:CI_OnlineResource>
              </gmd:onLine>

I've removed some extraneous namespace attributes from these eAtlas examples.
In the first example below, `gmd:onLine` tag looked like this: `<gmd:onLine xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xlink="http://www.w3.org/1999/xlink">`
...even though `gmx` is already declared, and there were no `srv` or `xlink`
prefixes.

The `gmd:linkage` tag in the second example below also had those same
unnecessary namespaces.

              <gmd:onLine>
                <gmd:CI_OnlineResource>
                  <gmd:linkage>
                    <gmd:URL>http://eatlas.org.au/data/uuid/c4d8abcc-650c-46de-ac06-e91985b368e7</gmd:URL>
                  </gmd:linkage>
                  <gmd:protocol>
                    <gco:CharacterString>WWW:LINK-1.0-http--metadata-URL</gco:CharacterString>
                  </gmd:protocol>
                  <gmd:description>
                    <gco:CharacterString>Point of truth URL of this metadata record</gco:CharacterString>
                  </gmd:description>
                </gmd:CI_OnlineResource>
              </gmd:onLine>

              <gmd:onLine>
                <gmd:CI_OnlineResource>
                  <gmd:linkage>
                    <gmd:URL>http://eprints.jcu.edu.au/2678/</gmd:URL>
                  </gmd:linkage>
                  <gmd:protocol>
                    <gco:CharacterString>WWW:LINK-1.0-http--link</gco:CharacterString>
                  </gmd:protocol>
                  <gmd:name xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xlink="http://www.w3.org/1999/xlink">
                    <gmx:MimeFileType type="" />
                  </gmd:name>
                  <gmd:description>
                    <gco:CharacterString>
                      Grech. A., and Marsh. H. (2007) - Prioritising areas
                      for dugong conservation in a marine protected area
                      using a spatially explicit population model,
                      Applied GIS, 3(2), 1-14.
                    </gco:CharacterString>
                  </gmd:description>
                </gmd:CI_OnlineResource>
              </gmd:onLine>

              <gmd:onLine>
                <gmd:CI_OnlineResource>
                  <gmd:linkage>
                    <gmd:URL>http://eatlas.org.au/data/uuid/71127e4d-9f14-4c57-9845-1dce0b541d8d</gmd:URL>
                  </gmd:linkage>
                  <gmd:protocol>
                    <gco:CharacterString>WWW:LINK-1.0-http--related</gco:CharacterString>
                  </gmd:protocol>
                  <gmd:name gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:name>
                  <gmd:description>
                    <gco:CharacterString>e-Atlas Web Mapping Service (WMS) (AIMS)</gco:CharacterString>
                  </gmd:description>
                </gmd:CI_OnlineResource>
              </gmd:onLine>

            </gmd:MD_DigitalTransferOptions>
          </gmd:transferOptions>

(Completing the distribution information.)

        </gmd:MD_Distribution>
      </gmd:distributionInfo>

### Data quality

This optional element describes the quality of the data in the dataset.

      <gmd:dataQualityInfo>
        <gmd:DQ_DataQuality>

You can specify the scope of this statement; an eAtlas example used a empty
element here (i.e. `<gmd:DQ_Scope />`), which GeoNetwork doesn't accept. For
anything we're using MCP2.0 for, you'll almost certainly want `dataset`.

          <gmd:scope>
            <gmd:DQ_Scope>
              <gmd:level>
                <gmd:MD_ScopeCode
                  codeList="https://github.com/aodn/schema-plugins/raw/master/iso19139.mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#MD_ScopeCode"
                  codeListValue="dataset"
                >dataset</gmd:MD_ScopeCode>
              </gmd:level>
            </gmd:DQ_Scope>
          </gmd:scope>

`report` covers qualitative quality information. You need either this or
`lineage`, or both.

`lineage` and the `statement` tag it contains should be a brief history of
the resource, the idea being that this is non-quantitative claims about the
data quality. eAtlas cites articles.

`lineage` can also include a series of `processStep` tags, each describing a
step in the processing of the data. `processStep`s can each have a description,
a rationale, a date/time (or range), a processor (the person or organisation
connected to that step), source data for that step, and some other stuff.

I'll document `processStep`s when I've seen some examples of it. For now,
refer to the [ANZLIC guidelines](http://www.anzlic.gov.au/sites/default/files/files/ANZLICmetadataProfileGuidelines_v1-2.pdf) for more information.

          <gmd:lineage>
            <gmd:LI_Lineage>
              <gmd:statement>
                <gco:CharacterString>
    - Grech. A., and Marsh. H. (2007) - Prioritising areas for dugong conservation in a marine protected area using a spatially explicit population model, Applied GIS, 3(2), 1-14
    - Marsh H., and Saalfeld, W.K. (1989). Distribution and abundance of dugongs in the Northern Great Barrier Reef Marine Park. Australian Wildlife Research 16:429-440.
    - Marsh H., and Saalfeld, W.K. (1990). The distribution and abundance of dugongs in the Great Barrier Reef Marine Park south of Cape Bedford. Australian Wildlife Research 17:511-524
    - Marsh H., and Sinclair D.F. (1989). Correcting for visibility bias in strip transect aerial surveys of aquatic fauna. Journal of Wildlife Management. 53(4): 1017-1024
                </gco:CharacterString>
              </gmd:statement>
            </gmd:LI_Lineage>
          </gmd:lineage>

If you really need to, you can supply a blank `statement` in your `lineage`
like this:

`<gmd:statement gco:nilReason="missing"><gco:CharacterString/></gmd:statement>`

..but the MCP docs *strongly* recommend supplying proper data quality
information.

        </gmd:DQ_DataQuality>
      </gmd:dataQualityInfo>

### Revision date

There's no documentation available on this tag, apart from
[a page](http://bluenet3.antcrc.utas.edu.au/mcp-doc-20-draft/mandatoryConditionalOptional/index.html)
that says it's mandatory, but examples seem to agree that it's just a `DateTime`
inside of a `mcp:revisionDate` tag.

      <mcp:revisionDate>
        <gco:DateTime>2015-07-01T21:09:02</gco:DateTime>
      </mcp:revisionDate>


(Completing the root element.)

    </mcp:MD_Metadata>



((TODO work in progress: go through these "important" items and check each one
is properly described.))

**Required fields listed in AODN cookbook http://help.aodn.org.au/help/?q=node/96 ):**

(all done)

**Other important fields**

- MD_MaintenanceInformation.maintenanceAndUpdateFrequency ‘continual’, ‘daily’, ‘weekly’, ‘fortnightly’, ‘monthly’, ‘quarterly’, ‘biannually’, ‘annually’, ‘asNeeded’, ‘irregular’, ‘notPlanned’, ‘unknown’ (ISO 19115:2003, B.5.18 MD_MaintenanceFrequencyCode)
- EX_VerticalExtent min and max metres
- mcp:samplingFrequency ‘continual’, ‘hourly’, ‘daily’, ‘weekly’, ‘fortnightly’, ‘monthly’, ‘quarterly’, ‘biannually’, ‘annually’, ‘asNeeded’, ‘irregular’, ‘notPlanned’, ‘unknown’. Reuses an extended ISO 19115:2003 B.5.18 MD_MaintenanceFrequencyCode
- CI_Citation additional info, eg. publications from this dataset

((TODO work in progress))


## De-literating this document

Below is a example of a script that can be used to extract XML and HTML from
the Markdown source of this document. The XML document is simply composed of
all the lines of the Markdown that have a four space indent, with the indent
removed.

This script assumes a Markdown processor is present (`commonmark`), and that
`header.html` and `footer.html` files exist that will be concatenated to the
top and bottom of the produced HTML.

The script provided is for Unix-type machines (OSX, Linux, BSD etc). If you
are using MS Windows you will need to do some rewriting.

<pre class="small">
#!/usr/bin/env bash
## content of deliterate.sh
#
# install commonmark:  npm install -g commonmark
#

MD_CONVERT_COMMAND="commonmark"
HTML_HEADER="./_includes/header.html"
HTML_FOOTER="./_includes/footer.html"

if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "deliterate - takes literate Markdown doc, renders to html, also extracts code."
  echo "Specify input file as first argument. Outputs HTML and XML."
  echo "Example: ./deliterate.sh mcp/annotated-mcp.md"
  echo "         (reads mcp/annotated-mcp.md, creates mcp/filename.md.html and mcp/filename.md.xml)"
  exit 1
fi

# use sed to...
#    keep lines that start  |   remove the four   >   save to
#      with four spaces,    |   leading spaces    >  output file.
sed -n -e "/^    /p" < "$1" | sed -e "s/^    //"  >  "$1.xml"

echo "wrote: $1.xml"

# also render markdown to html -- cat the header and footer in as well
cat "$HTML_HEADER" > "$1.html"
"$MD_CONVERT_COMMAND" < "$1" >> "$1.html"
cat "$HTML_FOOTER" >> "$1.html"

echo "wrote: $1.html"
</pre>
