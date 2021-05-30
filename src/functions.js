export const convertKo = (number) => {
    const x = number;
    let res;

    if (x >= Math.pow(1024, 3))
        res = Math.round(x / Math.pow(1024, 3)) + " To";
    else if (x >= Math.pow(1024, 2))
        res = Math.round(x / Math.pow(1024, 2)) + " Go";
    else if (x >= 1024) res = Math.round(x / 1024) + " Mo";
    else res = x + " Ko";

    return res;
}