--!nonstrict
-- Type definitions used by main.luau

export type AstExpression = {
    kind: string,
    data: { [string]: any }
}

export type AstBlock = {
    kind: string,
    data: {
        statements: { AstExpression }
    }
}

export type Spied = { [any]: any }

return {}
