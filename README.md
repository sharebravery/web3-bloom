# Solidity API

## PlantNFT

_基于 ERC721 标准_

### MAX_SUPPLY

```solidity
uint256 MAX_SUPPLY
```

### PRICE

```solidity
uint256 PRICE
```

### MAX_PER_MINT

```solidity
uint256 MAX_PER_MINT
```

### baseTokenURI

```solidity
string baseTokenURI
```

### constructor

```solidity
constructor(string _name, string _symbol) public
```

### Unauthorized

```solidity
error Unauthorized()
```

### NotEnoughNFTs

```solidity
error NotEnoughNFTs()
```

### NotEnoughEtherPurchaseNFTs

```solidity
error NotEnoughEtherPurchaseNFTs()
```

### CannotMintSpecifiedNumber

```solidity
error CannotMintSpecifiedNumber()
```

### CannotZeroBalance

```solidity
error CannotZeroBalance()
```

### _baseURI

```solidity
function _baseURI() internal view virtual returns (string)
```

_Base URI for computing {tokenURI}. If set, the resulting URI for each
token will be the concatenation of the `baseURI` and the `tokenId`. Empty
by default, can be overridden in child contracts._

### setBaseURI

```solidity
function setBaseURI(string _baseTokenURI) public
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view returns (string)
```

_See {IERC721Metadata-tokenURI}._

### mint

```solidity
function mint(uint256 _count) public payable returns (uint256)
```

铸造NFT

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _count | uint256 | 铸造数量 |

### reserveNFTs

```solidity
function reserveNFTs(uint256 _count) public
```

预留NFT

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _count | uint256 | 保留NFT数量 |

### getTokensOfOwner

```solidity
function getTokensOfOwner(address _owner) external view returns (uint256[])
```

获取一个特定账户所拥有的所有代币

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _owner | address | 拥有者 |

### withdraw

```solidity
function withdraw() external
```

提取合约余额

## PlantBase

公共合约，提供植物基础功能

### PlantWatered

```solidity
event PlantWatered(uint256 plantId, uint8 waterAmount)
```

### LightProvided

```solidity
event LightProvided(uint256 plantId, uint8 lightDuration)
```

### PlantGrown

```solidity
event PlantGrown(uint256 plantId, enum PlantBase.PlantStage newStage)
```

### PlantHarvested

```solidity
event PlantHarvested(uint256 plantId, address reciver)
```

### PlantTransferred

```solidity
event PlantTransferred(uint256 plantId, address form, address to)
```

### PlantSpecies

```solidity
enum PlantSpecies {
  Tree,
  Flower,
  Shrub
}
```

### PlantMetadata

```solidity
struct PlantMetadata {
  string plantName;
  enum PlantBase.PlantSpecies plantSpecies;
}
```

### Plant

```solidity
struct Plant {
  uint8 waterLevel;
  uint8 lightLevel;
  bool isAlive;
  enum PlantBase.PlantStage currentStage;
  struct PlantBase.PlantMetadata metadata;
}
```

### PlantStage

```solidity
enum PlantStage {
  Seed,
  Sprout,
  Mature,
  Flower,
  Harvest
}
```

### plantMap

```solidity
mapping(uint256 => struct PlantBase.Plant) plantMap
```

### userPlantIds

```solidity
mapping(address => uint256[]) userPlantIds
```

### createPlant

```solidity
function createPlant(string plantName, enum PlantBase.PlantSpecies plantSpecies) external returns (uint256)
```

创建植物并返回植物ID

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantName | string | 植物名称 |
| plantSpecies | enum PlantBase.PlantSpecies | 植物品种 |

### getUserPlantIds

```solidity
function getUserPlantIds() external view returns (uint256[])
```

获取用户地址拥有的植物ID数组

### getPlantIds

```solidity
function getPlantIds() external view returns (uint256[])
```

获取植物ID集合

### getPlantStatus

```solidity
function getPlantStatus(uint256 plantId) public view returns (string, enum PlantBase.PlantSpecies, uint8, uint8, bool, enum PlantBase.PlantStage, uint256)
```

获取植物状态信息

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |

### waterPlant

```solidity
function waterPlant(uint256 plantId, uint8 waterAmount) public
```

给植物浇水

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |
| waterAmount | uint8 | 水量 |

### provideLight

```solidity
function provideLight(uint256 plantId, uint8 lightDuration) public
```

提供光照

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |
| lightDuration | uint8 | 光照时长 |

### _updatePlantStatus

```solidity
function _updatePlantStatus(uint256 plantId, uint8 waterAmount, uint8 lightDuration) internal
```

合并状态更新操作，减少 gas 消耗

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |
| waterAmount | uint8 | 水量 |
| lightDuration | uint8 | 光照时长 |

### _growPlant

```solidity
function _growPlant(uint256 plantId) internal
```

促使植物生长

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |

### _checkPlantHealth

```solidity
function _checkPlantHealth(uint256 plantId) internal
```

检查植物是否健康，如果水分或光照不足，植物将死亡

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |

### _isPlantOwner

```solidity
function _isPlantOwner(address userAddress, uint256 plantId) internal view returns (bool)
```

检查用户是否拥有指定植物

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| userAddress | address | 用户地址 |
| plantId | uint256 | 植物ID |

### harvestPlant

```solidity
function harvestPlant(uint256 plantId) public
```

收获植物

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | plant id |

### transferPlant

```solidity
function transferPlant(address to, uint256 plantId) public
```

以下为交易植物功能

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | to |
| plantId | uint256 | plantId |

### _removePlantOwnership

```solidity
function _removePlantOwnership(address from, uint256 plantId) internal
```

### _addPlantOwnership

```solidity
function _addPlantOwnership(address to, uint256 plantId) internal
```

## MoneyTree

摇钱树植物的实现

### PlantCreationParams

结构体，用于组织创建植物时的参数

```solidity
struct PlantCreationParams {
  uint256 customAttribute;
  string color;
  string shape;
  uint8 growthSpeed;
  string name;
}
```

### plantAttributes

```solidity
struct MoneyTree.PlantCreationParams plantAttributes
```

### constructor

```solidity
constructor(struct MoneyTree.PlantCreationParams params) public
```

构造函数，初始化摇钱树

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct MoneyTree.PlantCreationParams | 创建植物的参数 |

## PingPongChrysanthemum

乒乓菊植物的实现

### PlantCreationParams

```solidity
struct PlantCreationParams {
  uint256 customAttribute;
  string color;
  string shape;
  uint8 growthSpeed;
  string name;
}
```

### plantAttributes

```solidity
struct PingPongChrysanthemum.PlantCreationParams plantAttributes
```

### constructor

```solidity
constructor(struct PingPongChrysanthemum.PlantCreationParams params) public
```

构造函数，初始化乒乓菊

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct PingPongChrysanthemum.PlantCreationParams | 创建植物的参数 |

## SevenDayFlower

七日花植物的实现

### PlantAttributes

```solidity
struct PlantAttributes {
  uint256 customAttribute;
  string color;
  string shape;
  uint8 growthSpeed;
  string name;
}
```

### plantAttributes

```solidity
struct SevenDayFlower.PlantAttributes plantAttributes
```

### constructor

```solidity
constructor(struct SevenDayFlower.PlantAttributes params) public
```

构造函数，初始化

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct SevenDayFlower.PlantAttributes | 创建植物的参数 |

## ResultLibrary

统一处理

### Result

```solidity
struct Result {
  uint256 value;
  string message;
}
```

### createResult

```solidity
function createResult(uint256 _value, string _message) internal pure returns (struct ResultLibrary.Result)
```

## ElectronicPlantBase

公共合约，提供植物基础功能

### PlantMetadata

```solidity
struct PlantMetadata {
  string plantName;
  string plantSpecies;
  uint256 creationTime;
}
```

### Plant

```solidity
struct Plant {
  uint8 waterLevel;
  uint8 lightLevel;
  bool isAlive;
  enum ElectronicPlantBase.PlantStage currentStage;
  struct ElectronicPlantBase.PlantMetadata metadata;
}
```

### PlantStage

```solidity
enum PlantStage {
  Seed,
  Sprout,
  Mature,
  Flower
}
```

### plantMap

```solidity
mapping(uint256 => struct ElectronicPlantBase.Plant) plantMap
```

### PlantWatered

```solidity
event PlantWatered(uint256 plantId, uint8 waterAmount)
```

事件，记录植物被浇水情况

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | plantId |
| waterAmount | uint8 | 水量 |

### LightProvided

```solidity
event LightProvided(uint256 plantId, uint8 lightDuration)
```

事件，记录植物被提供光照情况

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | plantId |
| lightDuration | uint8 | 光照时长 |

### PlantGrown

```solidity
event PlantGrown(uint256 plantId, enum ElectronicPlantBase.PlantStage newStage)
```

事件，记录植物生长阶段变化

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | plantId |
| newStage | enum ElectronicPlantBase.PlantStage | newStage |

### plantExists

```solidity
modifier plantExists(uint256 plantId)
```

修饰器，确保植物存在

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | plantId |

### _checkPlantHealth

```solidity
function _checkPlantHealth(uint256 plantId) internal
```

内部方法，检查植物健康状况

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | plantId |

### getPlantStatus

```solidity
function getPlantStatus(uint256 plantId) public view returns (string, string, uint8, uint8, bool, enum ElectronicPlantBase.PlantStage, uint256)
```

获取植物状态信息

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | plantName 植物名称 |
| [1] | string | plantSpecies 植物品种 |
| [2] | uint8 | waterLevel 水分级别 |
| [3] | uint8 | lightLevel 光照级别 |
| [4] | bool | isAlive 植物是否存活 |
| [5] | enum ElectronicPlantBase.PlantStage | currentStage 当前生长阶段 |
| [6] | uint256 | creationTime 植物创建时间 |

### waterPlant

```solidity
function waterPlant(uint256 plantId, uint8 waterAmount) public
```

给植物浇水

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |
| waterAmount | uint8 | 水量 |

### provideLight

```solidity
function provideLight(uint256 plantId, uint8 lightDuration) public
```

提供光照

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |
| lightDuration | uint8 | 光照时长 |

### growPlant

```solidity
function growPlant(uint256 plantId) public
```

促使植物生长

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |

### createPlant

```solidity
function createPlant(string plantName, string plantSpecies, uint256 creationTime) external returns (uint256)
```

创建植物并返回植物ID

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantName | string | 植物名称 |
| plantSpecies | string | 植物品种 |
| creationTime | uint256 | 植物的创建时间  记录植物合约创建的时间戳 |

### getPlantIds

```solidity
function getPlantIds() external view returns (uint256[])
```

获取植物ID集合

