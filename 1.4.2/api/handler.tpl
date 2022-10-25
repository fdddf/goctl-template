package {{.PkgName}}

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"github.com/go-playground/validator/v10"
	{{.ImportPackages}}
)

func {{.HandlerName}}(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		{{if .HasRequest}}var req types.{{.RequestType}}
		if err := httpx.Parse(r, &req); err != nil {
			httpx.OkJson(w, &types.StdReply{
				Code: http.StatusBadRequest,
				Message: err.Error(),
			})
			return
		}

		if err := validator.New().Struct(req); err != nil {
			httpx.OkJson(w, &types.StdReply{
				Code: http.StatusBadRequest,
				Message: err.Error(),
			})
			return
		}

		{{end}}l := {{.LogicName}}.New{{.LogicType}}(r.Context(), svcCtx)
		{{if .HasResp}}resp, {{end}}err := l.{{.Call}}({{if .HasRequest}}&req{{end}})
		if err != nil {
			httpx.OkJson(w, &types.StdReply{
				Code: http.StatusInternalServerError,
				Message: err.Error(),
			})
		} else {
			{{if .HasResp}}httpx.OkJson(w, &types.StdReply{
				Code: http.StatusOK,
				Data: resp,
			}){{else}}httpx.Ok(w){{end}}
		}
	}
}
