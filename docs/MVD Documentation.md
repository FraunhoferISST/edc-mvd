# EDC MVD

## About this document

This documentation is targeted towards **decision makers** and **software architects** to understand the MVD and how to apply or extend it. This presents
[Persona 2](https://https://github.com/orgs/eclipse-edc/discussions/61#discussioncomment-6625208), details about the different personas can be found in the documentation guidelines [documentation guidelines](https://github.com/orgs/eclipse-edc/discussions/61).


Persona 2 is most likely someone from a research or implementation project who assesses with the goal to create a dataspace-based use case. 


## Management Summary

This repository contains a set of integrated components in combination with a configuration setting to showcase the recent EDC functionalities. This includes not only extensions, configurations, but also example files and a demonstration scenario.

The EDC MVD is a sample implementation of a dataspace and demonstrates how decentralization can be realized.
The dataspace setup can be used as a starting point to gather requirements and implement a custom dataspace.

## MVD Elements

### Roles involved
The EDC MVD dataspace setup contains three participants and one dataspace authority.

 The participants represent different companies that want to exchange data with each other in a trustworthy and sovereign way. They are referred to as Company1, Company2, and Company3. To illustrate how different constraints and policies work, the three participating companies are identical besides their headquarter's location. While two companies have a European headquarter, one is based in the US.  The selection of location as a distinguishing criterion is an exemplary feature only, which is technically expressed accordingly with policies and credentials, which are checked at various points in the communication flow. Each participant offers two data sets in the EDC MVD.

 Explanations about the role Dataspace Authority are available in the  [Publications repository](https://github.com/eclipse-edc/Publications/tree/main/Dataspaces).

A particular relevant part is the mechanism for authorization and identification. While early dataspace approaches considered rather central approaches, the EDC components and extensions enable a decentralized approach. This decentralized approach relies on mechanisms of decentralized identifiers (DID) and self-sovereign identities (SSI). 

Note that the MVD is designed to be an open and decentral scenario. This means, you can add different Dataspace Authorities and more participants with different policies.

More explanation can be found in the functional requirement description in the [IDSA Rulebook](https://github.com/International-Data-Spaces-Association/IDSA-Rulebook/blob/main/documentation/3_Functional_Requirements.md).

### Technical Components

Per Dataspace Authority
- Registration Service
    -  the example includes *one* Dataspace Authority and as such one Registration Service.
    - Note that each participant is technically able to connect with different ones.

Per Participant 
- Connector
    - Control Plane
    - Data Plane
- Federated Catalog
    - Catalog Cache
    - Catalog Crawler
- Identity Hub
- Decentralized Identifier support components
    - secret storage *(Azure Key Vault)*
    - DID document storage
- Data Dashboard as graphical user interface



![Consumer components](https://github.com/FraunhoferISST/edc-mvd/blob/MVD-docs-enhancement-diagrams/resources/Consumer-%20Component%20Overview.png) 
![Provider components](https://github.com/FraunhoferISST/edc-mvd/blob/MVD-docs-enhancement-diagrams/resources/Provider-Komponenten%C3%BCbersicht.png)


 
## Component Deep Dive

The following paragraphs give a short explanation on each component, a glimpse at the communication flow, and provide ideas on how they could be enhanced.

The complete MVD set-up follows the [Dataspace Protocol (DSP)](https://https://docs.internationaldataspaces.org/ids-knowledgebase/v/dataspace-protocol/overview/readme) defined by the working group inside the non-profit organization [International Data Spaces Association (IDSA)](https://internationaldataspaces.org/). The protocol enables interoperability in and across dataspace components and complete dataspaces itself, by standardizing the communication between them. It builds on existing standards such as. The DSP becomes important when own components are integrated into the MVD, or if an integration with EDC MVD and other technologies is aspired. 

### Registration Service


**What**
The Registration Service has the main task to enable the technical entry into the dataspace. For this, identification and the authorization is relevant to prove that each applicant has a valid identity that fulfills the dataspace's rules identification rules, and can attest a set of relevant properties. These properties are checked in form of Verifiable Credentials and distinct attributes. The Registration Service also fulfils further supportive tasks such as seeding the catalog or remaining a list of all Connector URLs.

**Why**
It is important to note, that different dataspace authorities can exist. For example, for different sub-groups of suppliers for an OEM. Ideally, dataspace participants can use their connectors to connect to various dataspace authorities and, thus, joining different dataspaces.

**Governance and Operation**
Often, dataspaces are created by consortia that aspire a shared governance. This means, that the rules for the dataspace are decided as group. The decision is then implemented in form of policies and the operation mode(s) of the Dataspace Authority. Note that this does not mean, that a single consortium member or party has full control. 

**How**
![Simple registration flow](https://github.com/FraunhoferISST/edc-mvd/blob/MVD-docs-enhancement-diagrams/resources/Simplified%20registration%20service%20flow.png)


### Control Plane and Data Plane


**What**
The Control Plane and Data Plane together form the Connector.

Speaking generally, the Control Plane is a managing functionality and works as orchestrator for different dataspace participants and their artifacts or assets. A fundamental design principle of the EDC Connector is, that client artifacts should never be involved in the control plane communication flows. This ensures that all artifacts, such as data, are only shared out-of-band in a data plane flow, that is prepared and managed by the control planes. Simply put, this allows the actual artifacts to be made available via the dataspace only if the dataspace participant has created its conditions for them in the Control Plane, which checks and implements them, allowing the dataspace participant to trust its counterpart.

The Data Plane is suitable for being customized and commonly extended. There are some examples and reference implementations in the MVD and the EDC repository, but they are by no means normative. The reason for this is that the type of data exchange can be very individually use-case specific. For example, a use case might require a streaming solution. The existing interfaces in the EDC make it easy to develop and add your own Data Planes, as explained for example in the Samples. For many purposes, http Data Plans are often further extended and adapted. In general, it is recommended to pay close attention to the data space and the use cases when selecting a Data Plane.

**Why**
The separation of Data Plane and Control Plane is a key design characteristic of the EDC components. It has the benefits to make the system highly scalable, customizable, and especially suitable for different cloud environments or to integrate the EDC technologies into existing systems. More information on the EDC architecture fundamentals can be found [in the documentation](https://eclipse-edc.github.io/docs/#/), or, for example, in one of the [conference presentations](https://github.com/FraunhoferISST/edc-mvd/tree/MVD-docs-enhancement-diagrams).


When considering the detailed tasks of the Control Plane, they can be divided into four main groups:

- Metadata management: Describe and localize data offerings
- Contract handling: Managing the contract agreement process
- Policy enforcement: Check and enforce policies in different stages
- Prepare data exchange: The actual transfer is prepared and besides a policy check also additional resources for the exchange are provisioned

**Governance and Operation**
As in case of the other components, Data Plane and Control Plane oblige to the participants' governance and can be deployed separately. Often, a participant has multiple Data Planes in place for different purposes. In case of using a connector from a service provider (e.g., called connector-as-a-service), users can technically select their preferred service provider for the connector who don't necessarily has to be the same one as for the other components, and enables the basic functionality to adapt to different dataspaces. As well, the connector can also be used completely without any other component, such as in the [samples](https://github.com/eclipse-edc/Samples). Nevertheless, the [DSP](https://https://docs.internationaldataspaces.org/ids-knowledgebase/v/dataspace-protocol/overview/readme) and [IDSA Rulebook endorse a range of functionalities](https://docs.internationaldataspaces.org/ids-knowledgebase/v/idsa-rulebook/idsa-rulebook/3_functional_requirements) be fully prepared for operational dataspace participation and fully leverage the benefits of dataspaces.

**How**



### Federated Catalog

**What**
The Federated Catalog is, as it is named, concerned with publishing data offerings and searching for them without a central bottleneck. The Federated Catalog consists of two components, a Catalog Cache and a Catalog Crawler. Besides making offerings visible and initiating the contact between two participants, the Federated Catalog also manages the visibility of offerings according to policies, and allows a structured description of offerings.
While the Catalog Crawler is basically concerned with crawling the offerings of other participants, the Cache stores the offerings. To initially seed the participants with the URLs from others and enable their Federated Catalog's to communicate, the registration service provides a list of URLs. 

**Why**
Dataspaes assume that participants don't know each other, as well as which offerings under which condition the other party provides. Different dataspaces and different purposes also require different descriptions of offered assets, such as data but also services. 

**How**

### Data Dashboard

**What** The Data Dashboard is a graphical user interface that allows a natural person interact with the dataspace. It assumes that the person is a participant and concerned with making data assets available and searching for them, defining policies, and so on. In general, when considering a commercial use in  real-life application scenarios, the user interface is most likely to be provided from one of the partners involved in setting up the dataspace, or from the governing entity. This way, particular user interface designs and information demands can be addressed. Nevertheless, to understand dataspaces and work with the MVD, the available Data Dashboard fulfills all functionalities required.

**Why**
Provide an opportunity to use the functionalities of a dataspace with a user-friendly interface.
A further [Vision Demonstrator](https://github.com/eclipse-edc/MinimumViableDataspace/tree/main/Vision%20Demonstrator) showcases how a user interface for participants could look like when different dataspaces are addressed and multiple assets managed.

**How**


### Identity Hub


**What**

The identity hub is, contrary to the naming, not only relevant for identification and authentication. As well, the credentials stores inside the identity hub allow for authorization since they can refer to various aspects. For different trust models, different credentials can be stored and managed in the identity hub. The EDC Identity Hub presents a Decentralized Web Node as defined by the [Decentralized Identity Foundation](<https://identity.foundation/decentralized-web-node/spec/>).

**Why**
Dataspaces present a context of trust. In order to realizea  decentral way of trust and avoid bottlenecks of power and control, but also technological bottlenecks, each participant is responsible for their own identities. ...

**Governance and Operation**
The identity hub is under each participants' governance since the credentials typically address key trust-relevant aspects of each participant. It may be the case that a participant wants to use a managed service for the identity hub. In this case, the participant can select an identity hub provider according to own needs. Due to the standardized format of verifiable credentials and established standards to describe various properties, for example by using ODRL for policies, the identity hub enables to manage credentials and communications between different implementations.
The design and use of identification and authorization mechanisms is an important topic in dataspaces and the standards, tools, and procedures applied may vary between different dataspaces. Due to the strong emphasizes on [W3C Verifiable Credentials ](<https://www.w3.org/TR/vc-data-model/>) in different, large dataspace initiatives, the identity hub emerged as key component for many cases.

*How*
![Simple identity and authorization flow](<siplified identity flow.png>)
<!--- ![Simple identity and authorization flow](https://github.com/FraunhoferISST/edc-mvd/blob/MVD-docs-enhancement-diagrams/resources/siplified%20identity%20flow.png) -->



### Further Items

Each participant uses the DID:web method in the MVD. This means, each participant has a DID:document, as well as a public and private key. The private key is stored in a dedicated secrets storage, Azure Key Vault. To store the DID document, each participant has a separate storage as well.



## Aspects addressed with the MVD

### Policies
 


## How to use  for decision makers and software architects

### Requirement definition

A key benefit of the pre-defined MVD set-up is that it presents a blueprint to elaborate on requirements  in a prototype approach. By using a quite generic combination of components you can conceptualize and prototype your use case case scenario. Since the generic components used in the MVD are extensible, exchangeable and follow a modular design pattern, you can assess the different functionalities for the fit of your needs. Some components and communication flows may be just right, some might have constraints or don't fulfill expectations in terms of functional and non-functional requirements for your dataspace. By detecting these requirements and incrementally adapt the MVD to your individual dataspace project's needs, you can iteratively move towards a custom dataspace.

In particular the local deployment opportunity, pre-definition of a set of participants and policies, as well as provisioning of required certificates and credentials eases the entry in a prototype process. It reveals, where you can use existing open-source components, or where additional developments or exhaustive adaptions are required.
After being done with experimenting and a set of iterations, you are able to name the components and required elements, such as certificates, that are required for the next steps.

### Showcase, extend and adapt

In the following, you can find a non-exhaustive list how to use the MVD, in the form of some steps to extend or adapt the set-up. They are roughly sorted from easy/beginner-friendly, directing to those who want to understand dataspaces and the EDC components in general, up to expert/advanced, to those who have expert knowledge in some concrete dataspace technologies.

- An easy adjustment without any technical changes would be the change of the storyline according to your use case or domain. Instead of using the example with three companies an different located headquarters, you could also draw another storyline such as visualized here in the [user journey](https://github.com/eclipse-edc/Publications/tree/main/White%20paper).

- Another first step may be to have a more detailed look at the Data Plane. In the [samples](https://github.com/eclipse-edc/Samples), you find an explanation on how to create an own data plane.

- You can also insert your own json-ld context model into the MVD. This way, you can describe data offerings and policies according to your specific model.

- You may also have a look at the other [extensions](https://github.com/eclipse-edc/Connector/tree/main/extensions) available in the EDC repository, or those provided by the [Known Friends of EDC](https://github.com/eclipse-edc/.github/blob/522e71c362f4ea399bd29110a34bee1debbfe6a1/KNOWN_FRIENDS.md#L4).

- Further, you can fully leverage the EDC policy handling by using the interfaces to add an own policy management system and further enforce the policies.

- ... and much more.


## Updates
Note, that the EDC is intended to present the recent capabilities of the EDC project. However, it may not include all functionalities or the latest changes: Due to the size and scope of the broad range of components and extensions, not everything fits into the small demonstration set-up of the EDC MVD. However, you can add different components or extension to the MVD to customize it. You may need to adapt the details of connection to the three example participants.
Usually, the gitHub bump mechanisms automatically updates the MVD components with the latest versions of the components in their core repositories. In general, if you are not sure if a component of the MVD is in its' latest version, or want to investigate it in further detail, have a look at the repository. 

