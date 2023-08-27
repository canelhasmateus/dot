from itertools import groupby
from typing import TypeVar, Generic, Mapping, Sequence

from typing_extensions import Self, Protocol, runtime_checkable

D = TypeVar("D")


@runtime_checkable
class Dimensional(Protocol[D]):
    dimension: D

    @classmethod
    def data(cls, data: Sequence[Self]) -> Mapping[D, Self]:
        keyfunc = lambda i: i.dimension
        data = sorted(data, key=keyfunc)

        groups = []
        uniquekeys = []
        for k, g in groupby(data, keyfunc):
            groups.append(list(g))
            uniquekeys.append(k)

        return dict(zip(uniquekeys, groups))

    def __instancecheck__(self, instance):
        return hasattr("dimension", instance)


class DimensionData(Generic[D]):
    dimension: D
    ...

    def data(cls, data: Sequence[Self]) -> Mapping[D, Self]:
        ...


class ControlDimension:
    ...


class ControlBalance(DimensionData[ControlDimension]):
    dimension: ControlDimension
    balance: float


balance = ControlBalance()
result = Dimensional.data([balance])
reveal_type(result)
