--!nonstrict
--[[
    instances.luau
    Returns { InstanceLib, InstanceFuncs }

    InstanceLib: dict of ClassName -> { properties, methods, events, callbacks, tags }
    InstanceFuncs: dict of funcName -> function  (applied to every instance via MethodsHooks["*"])
]]

-- ── helpers ──────────────────────────────────────────────────────────────────

local function props(t) return t or {} end

-- Default "Object" data — every class falls back to this
local ObjectData = {
    properties = {
        Name          = { ValueType = "string"  },
        Parent        = { ValueType = "Instance" },
        ClassName     = { ValueType = "string"  },
        Archivable    = { ValueType = "boolean" },
    },
    methods   = {},
    events    = { AncestryChanged={}, Changed={}, ChildAdded={}, ChildRemoved={}, DescendantAdded={}, DescendantRemoving={} },
    callbacks = {},
    tags      = {},
}

-- ── InstanceLib ──────────────────────────────────────────────────────────────
local InstanceLib = {
    Object = ObjectData,

    -- DataModel
    DataModel = {
        properties = {
            Name         = { ValueType = "string"  },
            ClassName    = { ValueType = "string"  },
            PlaceId      = { ValueType = "number"  },
            GameId       = { ValueType = "number"  },
            JobId        = { ValueType = "string"  },
            CreatorId    = { ValueType = "number"  },
            CreatorType  = { ValueType = "string"  },
            PrivateServerId = { ValueType = "string" },
            PrivateServerOwnerId = { ValueType = "number" },
        },
        methods   = { GetService={}, FindService={}, GetObjects={} },
        events    = { Loaded={}, Close={} },
        callbacks = {},
        tags      = { "Service" },
    },

    -- Workspace / Model
    Workspace = {
        properties = {
            Name           = { ValueType = "string"  },
            ClassName      = { ValueType = "string"  },
            Gravity        = { ValueType = "number"  },
            FallenPartsDestroyHeight = { ValueType = "number" },
            FilteringEnabled = { ValueType = "boolean" },
            StreamingEnabled = { ValueType = "boolean" },
            CurrentCamera  = { ValueType = "Instance" },
            Terrain        = { ValueType = "Instance" },
        },
        methods   = { Raycast={}, FindPartOnRay={}, FindPartOnRayWithIgnoreList={} },
        events    = {},
        callbacks = {},
        tags      = { "Service" },
    },

    -- Players
    Players = {
        properties = {
            Name         = { ValueType = "string"  },
            ClassName    = { ValueType = "string"  },
            LocalPlayer  = { ValueType = "Instance" },
            MaxPlayers   = { ValueType = "number"  },
            PreferredPlayers = { ValueType = "number" },
            RespawnTime  = { ValueType = "number"  },
        },
        methods   = { GetPlayers={}, GetPlayerFromCharacter={}, GetCharacterAppearanceInfoAsync={} },
        events    = { PlayerAdded={}, PlayerRemoving={}, PlayerChatted={} },
        callbacks = {},
        tags      = { "Service" },
    },

    -- Player
    Player = {
        properties = {
            Name           = { ValueType = "string"  },
            ClassName      = { ValueType = "string"  },
            UserId         = { ValueType = "number"  },
            DisplayName    = { ValueType = "string"  },
            AccountAge     = { ValueType = "number"  },
            Character      = { ValueType = "Instance" },
            Team           = { ValueType = "Instance" },
            TeamColor      = { ValueType = "BrickColor" },
            ReplicationFocus = { ValueType = "Instance" },
            CameraMode     = { ValueType = "string"  },
            DevCameraOcclusionMode = { ValueType = "string" },
            DevComputerMovementMode = { ValueType = "string" },
            DevTouchMovementMode = { ValueType = "string" },
            Health         = { ValueType = "number"  },
            MaxHealth      = { ValueType = "number"  },
            RespawnLocation = { ValueType = "Instance" },
        },
        methods   = { GetMouse={}, Kick={}, IsInGroup={}, GetRankInGroup={}, GetRoleInGroup={} },
        events    = { CharacterAdded={}, CharacterRemoving={}, Chatted={} },
        callbacks = {},
        tags      = {},
    },

    -- Script / LocalScript / ModuleScript
    Script = {
        properties = {
            Name      = { ValueType = "string"  },
            ClassName = { ValueType = "string"  },
            Disabled  = { ValueType = "boolean" },
            Source    = { ValueType = "string"  },
        },
        methods   = {},
        events    = {},
        callbacks = {},
        tags      = {},
    },
    LocalScript  = { properties = { Name={ValueType="string"}, ClassName={ValueType="string"}, Disabled={ValueType="boolean"}, Source={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    ModuleScript = { properties = { Name={ValueType="string"}, ClassName={ValueType="string"}, Source={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },

    -- GUI
    ScreenGui         = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Enabled={ValueType="boolean"}, ResetOnSpawn={ValueType="boolean"} }, methods={}, events={}, callbacks={}, tags={} },
    Frame             = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Visible={ValueType="boolean"}, Size={ValueType="UDim2"}, Position={ValueType="UDim2"}, BackgroundColor3={ValueType="Color3"}, BackgroundTransparency={ValueType="number"} }, methods={}, events={}, callbacks={}, tags={} },
    TextLabel         = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Text={ValueType="string"}, TextColor3={ValueType="Color3"}, TextSize={ValueType="number"}, Font={ValueType="string"}, Visible={ValueType="boolean"} }, methods={}, events={}, callbacks={}, tags={} },
    TextButton        = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Text={ValueType="string"}, Visible={ValueType="boolean"} }, methods={}, events={ MouseButton1Click={}, MouseButton1Down={}, MouseButton1Up={} }, callbacks={}, tags={} },
    TextBox           = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Text={ValueType="string"}, Visible={ValueType="boolean"} }, methods={}, events={ FocusLost={}, Focused={} }, callbacks={}, tags={} },
    ImageLabel        = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Image={ValueType="string"}, Visible={ValueType="boolean"} }, methods={}, events={}, callbacks={}, tags={} },
    ImageButton       = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Image={ValueType="string"}, Visible={ValueType="boolean"} }, methods={}, events={ MouseButton1Click={} }, callbacks={}, tags={} },
    ScrollingFrame    = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Visible={ValueType="boolean"} }, methods={}, events={}, callbacks={}, tags={} },
    BillboardGui      = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    SurfaceGui        = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },

    -- 3D
    Part              = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Size={ValueType="Vector3"}, Position={ValueType="Vector3"}, CFrame={ValueType="CFrame"}, Anchored={ValueType="boolean"}, BrickColor={ValueType="BrickColor"}, Color={ValueType="Color3"}, Material={ValueType="string"}, Transparency={ValueType="number"}, CanCollide={ValueType="boolean"} }, methods={}, events={ Touched={}, TouchEnded={} }, callbacks={}, tags={} },
    MeshPart          = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, MeshId={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    UnionOperation    = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    SpecialMesh       = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, MeshType={ValueType="string"}, MeshId={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    Model             = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, PrimaryPart={ValueType="Instance"} }, methods={ GetModelCFrame={}, MoveTo={}, SetPrimaryPartCFrame={} }, events={}, callbacks={}, tags={} },
    Humanoid          = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Health={ValueType="number"}, MaxHealth={ValueType="number"}, WalkSpeed={ValueType="number"}, JumpPower={ValueType="number"}, DisplayName={ValueType="string"} }, methods={ TakeDamage={}, GetAppliedDescription={} }, events={ Died={}, HealthChanged={}, StateChanged={} }, callbacks={}, tags={} },
    Terrain           = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ FillBlock={}, FillBall={}, FillCylinder={}, ReadVoxels={}, WriteVoxels={} }, events={}, callbacks={}, tags={} },
    Camera            = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, CFrame={ValueType="CFrame"}, FieldOfView={ValueType="number"}, CameraType={ValueType="string"}, Focus={ValueType="CFrame"} }, methods={ ScreenPointToRay={}, ViewportPointToRay={} }, events={}, callbacks={}, tags={} },

    -- Services
    RunService        = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ IsClient={}, IsServer={}, IsStudio={}, IsRunning={}, IsEdit={} }, events={ Heartbeat={}, Stepped={}, RenderStepped={} }, callbacks={}, tags={ "Service" } },
    ReplicatedStorage = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    ReplicatedFirst   = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    StarterGui        = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, ScreenOrientation={ValueType="string"}, ShowDevelopmentGui={ValueType="boolean"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    StarterPack       = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    StarterPlayer     = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    Lighting          = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Brightness={ValueType="number"}, ClockTime={ValueType="number"}, Ambient={ValueType="Color3"}, OutdoorAmbient={ValueType="Color3"}, FogColor={ValueType="Color3"}, FogEnd={ValueType="number"}, FogStart={ValueType="number"} }, methods={ GetMinutesAfterMidnight={}, SetMinutesAfterMidnight={} }, events={ LightingChanged={} }, callbacks={}, tags={ "Service" } },
    Teams             = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    SoundService      = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    TweenService      = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ Create={}, GetValue={} }, events={}, callbacks={}, tags={ "Service" } },
    HttpService       = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ JSONEncode={}, JSONDecode={}, GetAsync={}, PostAsync={}, RequestAsync={} }, events={}, callbacks={}, tags={ "Service" } },
    UserInputService  = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, TouchEnabled={ValueType="boolean"}, GamepadEnabled={ValueType="boolean"}, KeyboardEnabled={ValueType="boolean"}, MouseEnabled={ValueType="boolean"} }, methods={ GetKeysPressed={}, GetMouseLocation={}, GetMouseDelta={} }, events={ InputBegan={}, InputChanged={}, InputEnded={} }, callbacks={}, tags={ "Service" } },
    MarketplaceService = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ GetProductInfo={}, PromptProductPurchase={}, PromptPurchase={} }, events={ PromptProductPurchaseFinished={}, PromptPurchaseFinished={} }, callbacks={}, tags={ "Service" } },
    Chat              = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    LocalizationService = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    TestService       = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    PathfindingService = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ CreatePath={} }, events={}, callbacks={}, tags={ "Service" } },
    CollectionService  = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ GetTagged={}, HasTag={}, AddTag={}, RemoveTag={}, GetTags={} }, events={}, callbacks={}, tags={ "Service" } },
    DataStoreService   = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ GetDataStore={}, GetGlobalDataStore={} }, events={}, callbacks={}, tags={ "Service" } },
    PhysicsService     = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    AnalyticsService   = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },
    TextService        = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ GetTextSize={}, FilterStringAsync={} }, events={}, callbacks={}, tags={ "Service" } },
    VirtualInputManager = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={ "Service" } },

    -- Sound
    Sound  = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, SoundId={ValueType="string"}, Volume={ValueType="number"}, Pitch={ValueType="number"}, Looped={ValueType="boolean"}, Playing={ValueType="boolean"}, TimeLength={ValueType="number"}, TimePosition={ValueType="number"} }, methods={ Play={}, Pause={}, Stop={}, Resume={} }, events={ Ended={}, Played={}, Paused={}, Stopped={} }, callbacks={}, tags={} },
    SoundGroup = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },

    -- Animations
    Animation         = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, AnimationId={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    AnimationTrack    = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ Play={}, Stop={}, AdjustSpeed={}, AdjustWeight={} }, events={ Ended={}, Stopped={}, KeyframeReached={} }, callbacks={}, tags={} },
    Animator          = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ LoadAnimation={} }, events={}, callbacks={}, tags={} },

    -- Tween / Effects
    Tween             = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, PlaybackState={ValueType="string"} }, methods={ Play={}, Pause={}, Cancel={} }, events={ Completed={} }, callbacks={}, tags={} },
    TweenInfo         = { properties={}, methods={}, events={}, callbacks={}, tags={} },

    -- Misc
    StringValue   = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Value={ValueType="string"} }, methods={}, events={ Changed={} }, callbacks={}, tags={} },
    IntValue      = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Value={ValueType="number"} }, methods={}, events={ Changed={} }, callbacks={}, tags={} },
    NumberValue   = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Value={ValueType="number"} }, methods={}, events={ Changed={} }, callbacks={}, tags={} },
    BoolValue     = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Value={ValueType="boolean"} }, methods={}, events={ Changed={} }, callbacks={}, tags={} },
    ObjectValue   = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Value={ValueType="Instance"} }, methods={}, events={ Changed={} }, callbacks={}, tags={} },
    RemoteEvent   = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ FireServer={}, FireClient={}, FireAllClients={} }, events={ OnClientEvent={}, OnServerEvent={} }, callbacks={}, tags={} },
    RemoteFunction = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ InvokeServer={}, InvokeClient={} }, events={}, callbacks={ OnClientInvoke={}, OnServerInvoke={} }, tags={} },
    BindableEvent  = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ Fire={} }, events={ Event={} }, callbacks={}, tags={} },
    BindableFunction = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={ Invoke={} }, events={}, callbacks={ OnInvoke={} }, tags={} },
    Folder        = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    Configuration = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    Tool          = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, RequiresHandle={ValueType="boolean"} }, methods={}, events={ Equipped={}, Unequipped={}, Activated={}, Deactivated={} }, callbacks={}, tags={} },

    -- Particles / Effects
    ParticleEmitter = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Enabled={ValueType="boolean"} }, methods={ Emit={} }, events={}, callbacks={}, tags={} },
    SelectionBox    = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    SelectionSphere = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },

    -- Constraints / Physics
    WeldConstraint     = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    Motor6D            = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    BodyVelocity       = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Velocity={ValueType="Vector3"} }, methods={}, events={}, callbacks={}, tags={} },
    BodyPosition       = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Position={ValueType="Vector3"} }, methods={}, events={}, callbacks={}, tags={} },
    BodyGyro           = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
    BodyAngularVelocity = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },

    -- Attachments
    Attachment  = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"}, Position={ValueType="Vector3"} }, methods={}, events={}, callbacks={}, tags={} },
    Bone        = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },

    -- Spawn location etc.
    SpawnLocation = { properties={ Name={ValueType="string"}, ClassName={ValueType="string"} }, methods={}, events={}, callbacks={}, tags={} },
}

-- ── Class hierarchy for IsA ───────────────────────────────────────────────────
local ClassParents = {
    DataModel         = "Instance",
    Workspace         = "Model",
    Model             = "PVInstance",
    PVInstance        = "Instance",
    Players           = "Instance",
    Player            = "Instance",
    Humanoid          = "Instance",
    BasePart          = "PVInstance",
    Part              = "BasePart",
    MeshPart          = "BasePart",
    UnionOperation    = "BasePart",
    SpecialMesh       = "Instance",
    Script            = "BaseScript",
    LocalScript       = "BaseScript",
    ModuleScript      = "Instance",
    BaseScript        = "Instance",
    Terrain           = "BasePart",
    Camera            = "Instance",
    GuiObject         = "GuiBase2d",
    GuiBase2d         = "Instance",
    Frame             = "GuiObject",
    TextLabel         = "GuiObject",
    TextButton        = "GuiButton",
    TextBox           = "GuiObject",
    ImageLabel        = "GuiObject",
    ImageButton       = "GuiButton",
    GuiButton         = "GuiObject",
    ScrollingFrame    = "GuiObject",
    ScreenGui         = "LayerCollector",
    LayerCollector    = "GuiBase",
    GuiBase           = "Instance",
    BillboardGui      = "LayerCollector",
    SurfaceGui        = "LayerCollector",
    Sound             = "Instance",
    SoundGroup        = "Instance",
    Animation         = "Instance",
    AnimationTrack    = "Instance",
    Animator          = "Instance",
    Tween             = "TweenBase",
    TweenBase         = "Instance",
    RemoteEvent       = "Instance",
    RemoteFunction    = "Instance",
    BindableEvent     = "Instance",
    BindableFunction  = "Instance",
    StringValue       = "ValueBase",
    IntValue          = "ValueBase",
    NumberValue       = "ValueBase",
    BoolValue         = "ValueBase",
    ObjectValue       = "ValueBase",
    ValueBase         = "Instance",
    Folder            = "Instance",
    Configuration     = "Instance",
    Tool              = "BackpackItem",
    BackpackItem      = "Instance",
    ParticleEmitter   = "Instance",
    SelectionBox      = "Instance",
    SelectionSphere   = "Instance",
    WeldConstraint    = "Instance",
    Motor6D           = "JointInstance",
    JointInstance     = "Instance",
    BodyVelocity      = "Instance",
    BodyPosition      = "Instance",
    BodyGyro          = "Instance",
    BodyAngularVelocity = "Instance",
    Attachment        = "Instance",
    Bone              = "Attachment",
    SpawnLocation     = "BasePart",
    RunService        = "Instance",
    ReplicatedStorage = "Instance",
    ReplicatedFirst   = "Instance",
    StarterGui        = "Instance",
    StarterPack       = "Instance",
    StarterPlayer     = "Instance",
    Lighting          = "Instance",
    Teams             = "Instance",
    SoundService      = "Instance",
    TweenService      = "Instance",
    HttpService       = "Instance",
    UserInputService  = "Instance",
    MarketplaceService = "Instance",
    Chat              = "Instance",
    LocalizationService = "Instance",
    TestService       = "Instance",
    PathfindingService = "Instance",
    CollectionService  = "Instance",
    DataStoreService   = "Instance",
    PhysicsService     = "Instance",
    TextService        = "Instance",
}

-- ── InstanceFuncs ────────────────────────────────────────────────────────────
local InstanceFuncs = {}

-- IsA(className, checkClass) → boolean
function InstanceFuncs.IsA(className : string, checkClass : string) : boolean
    if className == checkClass then return true end
    local parent = ClassParents[className]
    if parent then return InstanceFuncs.IsA(parent, checkClass) end
    return false
end

-- FindFirstChild, etc. are handled by MethodsHooks["*"] in main.luau
-- InstanceFuncs here is for methods iterated with `for funcName, func in next, InstanceFuncs`
-- Those get wrapped and added to MethodsHooks["*"].
-- We only need IsA to be real; rest can be stubs if needed.

return { InstanceLib, InstanceFuncs }
