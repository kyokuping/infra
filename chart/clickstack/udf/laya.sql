CREATE OR REPLACE FUNCTION laya_prob AS (state, condition) ->
    JSONExtract(
        laya_raw(concat(
            '{"model":"aac6fef/laya-mlx","state":', toJSONString(substring(state, 1, 1500)),
            ',"questions":{"q":{"type":"noul","instructions":', toJSONString(condition), '}}}'
        )),
        'answers', 'q', 'noul', 'Nullable(Float64)'
    );
