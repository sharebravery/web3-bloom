# Solidity API

## ElectronicPlantBase

公共合约，提供植物基础功能

### Plant

```solidity
struct Plant {
  uint8 waterLevel;
  uint8 lightLevel;
  bool isAlive;
  enum ElectronicPlantBase.PlantStage currentStage;
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
function getPlantStatus(uint256 plantId) public view returns (uint8, uint8, bool, enum ElectronicPlantBase.PlantStage)
```

获取植物状态信息

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantId | uint256 | 植物ID |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint8 | waterLevel 水分级别 |
| [1] | uint8 | lightLevel 光照级别 |
| [2] | bool | isAlive 植物是否存活 |
| [3] | enum ElectronicPlantBase.PlantStage | currentStage 当前生长阶段 |

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

### getPlantIds

```solidity
function getPlantIds() external view returns (uint256[])
```

获取植物ID集合

## PlantFactory

创建不同类型植物的工厂合约

### plantContracts

```solidity
mapping(uint256 => address) plantContracts
```

### constructor

```solidity
constructor(address initialOwner) public
```

### createPlant

```solidity
function createPlant(uint256 plantType) external returns (address)
```

创建植物

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantType | uint256 | 植物类型 |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | 新植物合约地址 |

### getPlantContractAddress

```solidity
function getPlantContractAddress(uint256 plantType) external view returns (address)
```

获取植物合约地址

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| plantType | uint256 | 植物类型 |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | 植物合约地址 |

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

